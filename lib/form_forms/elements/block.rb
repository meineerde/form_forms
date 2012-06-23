module FormForms
  module Elements
    class Block < SubForm
      def initialize(element, args = {})
        @element = element.to_sym
        self.args args
        super
      end

      property :args

      # Generate a fielset with a legend
      def render(builder, view)
        return unless render_me?(builder, view)

        args = eval_property(:args, builder, view)
        view.content_tag(@element, args) do
          render_elements(builder, view)
        end
      end
    end
  end
end