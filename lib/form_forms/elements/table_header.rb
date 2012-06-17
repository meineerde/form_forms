module FormForms
  module Elements
    class TableHeader < BaseElement
      allowed_sub_element :field, element_class_name(:table_header_field)

      def initialize(row_args={})
        self.row_args row_args
        super
      end

      property :row_args

      def render(builder, view)
        return "" if self.elements.empty?

        row_args = eval_property(:row_args, builder, view)
        view.content_tag(:tr, row_args) do
          super
        end
      end
    end
  end
end
