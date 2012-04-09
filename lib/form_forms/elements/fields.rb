module FormForms
  module Elements
    # The generic form for building a simple_form..
    #
    # This class is only usable as a top-level form as it generates its own
    # form builder object
    class Fields < BaseElement
      allowed_sub_element :field
      allowed_sub_element :fieldset
      allowed_sub_element :fields
      allowed_sub_element :table_fields

      def initialize(form_args={})
        self.for{|f| nil}
        self.args{|f| form_args}
        super
      end

      property :for, :fields_for
      property :args, :form_args

      def render(model, view)
        fields_for = view.instance_exec(builder, &self.for)
        form_args = view.instance_exec(builder, &self.args)

        view.simple_fields_for(fields_for, args) do |builder|
          render_elements(builder, view)
        end
      end
    end
  end
end