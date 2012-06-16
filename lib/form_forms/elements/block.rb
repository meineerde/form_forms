module FormForms
  module Elements
    class Block < BaseElement
      allowed_sub_element :field
      allowed_sub_element :block
      allowed_sub_element :fieldset
      allowed_sub_element :fields
      allowed_sub_element :table_fields

      def initialize(element, args = {})
        @element = element.to_sym
        self.args args
        super
      end

      property :args

      # Generate a fielset with a legend
      def render(builder, view)
        args = view.instance_exec(builder, &self.args)

        view.content_tag(@element, args) do
          super
        end
      end
    end
  end
end