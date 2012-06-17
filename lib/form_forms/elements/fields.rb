module FormForms
  module Elements
    class Fields < SubForm
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