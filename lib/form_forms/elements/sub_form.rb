module FormForms
  module Elements
    class SubForm < BaseElement
      include FormForms::Mixins::ConditionalRendering

      allowed_sub_element :field
      allowed_sub_element :sub_form
      allowed_sub_element :block
      allowed_sub_element :fieldset
      allowed_sub_element :fields
      allowed_sub_element :table_fields
      allowed_sub_element :partial

      def render(builder, view)
        return unless render_me?(builder, view)
        super
      end
    end
  end
end
