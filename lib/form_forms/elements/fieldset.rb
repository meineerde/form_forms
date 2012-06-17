module FormForms
  module Elements
    class Fieldset < SubForm
      def initialize(args={}, &generator)
        self.legend nil
        self.args args

        super
      end

      property :args
      property :legend

      # Generate a fielset with a legend
      def render(builder, view)
        args = eval_property(:args, builder, view)
        legend = eval_property(:legend, builder, view)

        view.content_tag(:fieldset, args) do
          view.concat view.content_tag(:legend, legend) unless legend.nil?
          view.concat render_elements(builder, view)
        end
      end
    end
  end
end