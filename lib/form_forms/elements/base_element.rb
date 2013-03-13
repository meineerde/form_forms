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

      def delete(name)
        @elements.delete(name)
        @generators.delete(name)
        nil
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
        klass ||= element_class_name(type)
        klass = klass.name if klass.is_a?(Class)

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{type}(name, *args, &block)
            name = name.to_sym

            if block_given?
              element(name, #{klass}.new(*args, &block))
            else
              @generators[name]
            end
          end
          alias_method :#{type}_last, :#{type}

          def #{type}_first(name, *args, &block)
            element_before(nil, name.to_sym, #{klass}.new(*args, &block))
          end

          def #{type}_before(before, name, *args, &block)
            element_before(before.to_sym, name.to_sym, #{klass}.new(*args, &block))
          end

          def #{type}_after(after, name, *args, &block)
            element_after(after.to_sym, name.to_sym, #{klass}.new(*args, &block))
          end
        RUBY
      end

      def self.element_class_name(type)
        "::FormForms::Elements::#{type.to_s.camelize}"
      end

      # Define a property of the element. Properties can either be given as
      # a block, similar to the fields, or as a static object. Internally,
      # we always use the block form.
      def self.property(name, instance_variable=nil)
        instance_variable ||= name

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}(param=indicator=true, &generator)   # def legend(param=indicator=true, &generator
            if block_given?                               #   if block_given?
              @#{instance_variable} = generator           #     @legend = generator
            elsif indicator.nil?                          #   elsif indicator.nil?  # parameter was given
              @#{instance_variable} = param               #     @legend = param
            else                                          #   else
              @#{instance_variable}                       #     @legend
            end                                           #   end
          end                                             # end
        RUBY
      end

      # Get the actual value of a parameter. If the parameter was set with a
      # block or a lambda, evaluate the lambda in the context of the view
      # and return the result. This can be used for delayed evaluation of
      # parameter arguments.
      def eval_property(name, builder, view)
        property = self.send(name.to_sym)
        if property.is_a?(Proc)
          view.instance_exec(builder, &property)
        else
          property
        end
      end

      # Append a generic element to the end of the elements list. This method
      # is supposed tpo be called by the generated public methods of each
      # sub-element type.
      def element(name, generator)
        @elements << name unless @elements.include? name
        @generators[name] = generator
      end

      # Insert an element directly after an existing alement. The element
      # +name+ can not be defined in the current form scope yet. The +after+
      # element has to exist or be nil. If it is nil, the new element is
      # appended to the end of the element list.
      def element_after(after, name, generator)
        if @elements.include? name
          # Only allow new elements. Existing fields can be changed with #element
          raise ArgumentError.new("#{name} is already registered.")
        end

        after_index = @elements.index(after)
        if !after.nil? && after_index.nil?
          # This method makes only sense if the before element actually exists
          raise ArgumentError.new("#{after} is not registered. I can't insert after it.")
        elsif after.nil? || after_index == @elements.length-1
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
      # element has to exist or be nil. If it is nil, the new element is added
      # at the very beginning of the list.
      def element_before(before, name, generator)
        before_index = @elements.index(before)

        if @elements.include? name
          # Only allow new elements. Existing fields can be changed with #element
          raise ArgumentError.new("#{name} is already registered.")
        elsif !before.nil? && before_index.nil?
          # This method makes only sense if the before element actually exists
          raise ArgumentError.new("#{before} is not registered. I can't insert before it.")
        end

        # Perform an insert
        if before.nil?
          # insert at the beginning of the list
          @elements.unshift(name)
        else
          # insert the element before the named one
          @elements.insert(before_index, name)
        end
        @generators[name] = generator
      end

      # Render all elements in the current
      def render_elements(builder, view, before="", after="\n")
        @elements.each do |name|
          view.concat before
          view.concat @generators[name].render(builder, view)
          view.concat after
        end
      end
    end
  end
end
