module FormForms
  module Elements
    class Fields < BaseElement
      allowed_sub_element :field
      allowed_sub_element :block
      allowed_sub_element :fieldset
      allowed_sub_element :fields
      allowed_sub_element :table_fields

      def initialize(association=nil, form_args={})
        self.association association
        self.args form_args
        super
      end

      property :association
      property :args

      def render(builder, view)
        association = eval_property(:association, builder, view)
        form_args = eval_property(:args, builder, view)

        builder.association(association, form_args) do |sub|
          render_elements(sub, view)
        end
      end
    end
  end
end