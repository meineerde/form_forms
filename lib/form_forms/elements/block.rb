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
        args = eval_property(:args, builder, view)

        view.content_tag(@element, args) do
          super
        end
      end
    end
  end
end