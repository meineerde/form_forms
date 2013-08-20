module FormForms
  module Elements
    class Input < BaseElement
      include FormForms::Mixins::ConditionalRendering

      def initialize(options={}, &input)
        self.if options.delete(:if) if options.key?(:if)
        self.unless options.delete(:unless) if options.key?(:unless)

        self.options options
        self.input input if block_given?
      end

      property :options
      property :input

      def render(builder, view)
        return unless render_me?(builder, view)

        options = eval_property(:options, builder, view)
        if self.input
          builder.input(self.name, options, &self.input)
        else
          builder.input(self.name, options)
        end
      end
    end
  end
end
