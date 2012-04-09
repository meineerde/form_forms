module FormForms
  module Elements
    class Fieldset < Block
      def initialize(fieldset_args={}, &generator)
        self.legend{|f| nil}
        super(:fieldset, fieldset_args, &generator)
      end

      property :legend

      # Generate a fielset with a legend
      def render(builder, view)
        args = view.instance_exec(builder, &self.args)
        legend = view.instance_exec(builder, &self.legend)

        view.content_tag :fieldset, args) do
          view.concat view.content_tag(:legend, legend) unless legend.nil?
          view.concat render_elements(builder, view)
        end
      end
    end
  end
end