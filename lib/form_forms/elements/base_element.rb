require 'active_support/core_ext/string'

module FormForms
  module Elements
    # The generic base class for the FormForms
    class BaseElement
      def initialize(*)
        @elements = []
        @generators = {}

        yield self
      end

      attr_reader :elements

      # Render all of the elements of the current FormForm in their defined
      # order. This method is expected to be called by sub-classes in the
      # rendering chain. The parameters are a form builder object and an
      # action view instance.
      #
      # The form builder is typically created by a "special" FormForm class
      # and passed on to its sub-elements. See +FormForms::Forms::Form+
      # for an implementation of such a special form.
      def render(builder, view)
        render_elements(builder, view)
      end

    protected

      # Allow the passed form type as a sub-element of the current form.
      # Sub-elements must have a unique name inside the current form scope.
      # They can be of any allowed type.
      #
      # Elements can be added to the form using the generated +type+,
      # +type_before+, and +type_after+ methods. Element definitions can be
      # overridden by setting the element again with the same name.
      #
      # Example:
      #
      #   class MyForm < BaseForm
      #     allowed_sub_element(:field)
      #   end
      #
      #   my_form = MyForm.new() do |form|
      #     form.field(:subject) {|f| f.input :subject}
      #     form.field(:description) {|f| f.text_field :description}
      #   end
      #
      #   my_form.field_before(:description, :name) {|f| f.input :name}
      #
      #   my_form.elements
      #   # => [:subject, :name, :description]

      def self.allowed_sub_element(type, klass=nil)
        klass ||= "::FormForms::Elements::#{type.to_s.classify}"

        class_eval <<-RUBY, __FILE__, __LINE__
          def #{type}(name, *args, &block)
            name = name.to_sym

            if block_given?
              element(name, #{klass}.new(*args, &block))
            else
              @elements[name]
            end
          end

          def #{type}_before(before, name, *args, &block)
            element_before(before.to_sym, name.to_sym, #{klass}.new(*args, &block))
          end

          def #{type}_after(after, name, *args, &block)
            element_after(after.to_sym, name.to_sym, #{klass}.new(*args, &block))
          end
        RUBY
      end

      # Append a generic element to the end of the elements list. This method
      # is supposed tpo be called by the generated public methods of each
      # sub-element type.
      def element(name, generator)
        @elements << name unless @elements.include? name
        @generators[name] = generator
      end

      # Insert an element directly after an existing alement. The element
      # +name+ can not be defined in the current form scope yet. If the
      # +after+ element does not exist, the new element is added at the end
      # of the element list.
      def element_after(after, name, generator)
        if @elements.include? name
          # Only allow new elements. Existing fields can be changed with #element
          raise ArgumentError.new("#{name} is already registered.")
        end

        after_index = @elements.index(after.to_sym)
        if after_index.nil? || after_index == @elements.length-1
          # Append at the end
          element(name, generator)
        else
          # Perform an insert
          @elements.insert(after_index+1, name)
          @generators[name] = generator
        end
      end

      # Inserts an element directly before an existing alement. The element
      # +name+ can not be defined in the current form scope yet. The +before+
      # element has to exist.
      def element_before(before, name, generator)
        before_index = @elements.index(before)

        if @elements.include? name
          # Only allow new elements. Existing fields can be changed with #element
          raise ArgumentError.new("#{name} is already registered.")
        elsif before_index.nil?
          # This method makes only sense if the before element actually exists
          raise ArgumentError.new("#{before} is not registered. I can't insert before it.")
        end

        # Perform an insert
        @elements.insert(before_index, name)
        @generators[name] = generator
      end

      # Render all elements in the current
      def render_elements(builder, view, before="", after="\n")
        buffer = ActiveSupport::SafeBuffer.new

        @elements.inject(buffer) do |buffer, name|
          buffer << before
          buffer << @generators[name].render(builder, view)
          buffer << after
          buffer
        end
      end
    end
  end
end