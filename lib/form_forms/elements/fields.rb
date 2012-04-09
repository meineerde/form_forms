module FormForms
  module Elements
    class Fields < BaseElement
      allowed_sub_element :field
      allowed_sub_element :block
      allowed_sub_element :fieldset
      allowed_sub_element :fields
      allowed_sub_element :table_fields

      def initialize(for_field=nil, form_args={})
        self.for{|f| for_field}
        self.args{|f| form_args}
        super
      end

      property :for
      property :args

      def render(builder, view)
        fields_for = view.instance_exec(builder, &self.for)
        form_args = view.instance_exec(builder, &self.args)

        view.simple_fields_for(fields_for, args) do |sub_builder|
          render_elements(sub_builder, view)
        end
      end
    end
  end
end