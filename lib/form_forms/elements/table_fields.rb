module FormForms
  module Elements
    class TableFields < BaseElement
      include FormForms::Mixins::ConditionalRendering

    protected
      # For an allowed_sub_element, create a subclass which renders the
      # element as a table cell. It wrapps the rendering of the original
      # element in an HTML td tag.
      # To allow to customize the tag, it adds a new property called
      # +cell_args+ to the subclass which allows to set additional arguments
      # to the +td+ tag.
      def self.wrap_sub_element(type)
        parent = element_class_name(type)

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          class #{parent.demodulize} < #{parent}
            def initialize(*args, &block)
              self.cell_args {}
              super
            end

            property :cell_args

            def render(builder, view)
              cell_args = eval_property(:cell_args, builder, view)
              view.content_tag(:td, cell_args) do
                super
              end
            end
          end
        RUBY

        "FormForms::Elements::TableFields::#{parent.demodulize}"
      end

    public
      allowed_sub_element :field, wrap_sub_element(:field)
      allowed_sub_element :sub_form, wrap_sub_element(:sub_form)
      allowed_sub_element :block, wrap_sub_element(:block)
      allowed_sub_element :fieldset, wrap_sub_element(:fieldset)
      allowed_sub_element :fields, wrap_sub_element(:fields)
      allowed_sub_element :partial, wrap_sub_element(:partial)

      def initialize(association, form_args={})
        self.association association
        self.args form_args
        self.table_args {}
        self.row_args {}

        super
      end

      property :association
      property :args
      property :table_args
      property :row_args

      def header(row_args = {}, &generator)
        @header = TableHeader.new(row_args, &generator) if block_given?
        @header
      end

      def render(builder, view)
        association = eval_property(:association, builder, view)
        form_args = eval_property(:args, builder, view)
        table_args = eval_property(:table_args, builder, view)

        view.content_tag(:table, table_args) do
          # render the header row
          view.concat view.content_tag(:thead, header.render(builder, view)) if @header

          # render the table body
          body = builder.association(association, form_args) do |sub_builder|
            row_args = eval_property(:row_args, sub_builder, view)
            view.content_tag(:tr, row_args) do
              super(sub_builder, view)
            end
          end
          view.concat view.content_tag(:tbody, body)
        end
      end

    end
  end
end
