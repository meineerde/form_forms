module FormForms
  module Elements
    class InputField < BaseElement
      include FormForms::Mixins::ConditionalRendering

      def initialize(options={})
        self.if options.delete(:if) if options.key?(:if)
        self.unless options.delete(:unless) if options.key?(:unless)

        self.options options
      end

      property :options

      def render(builder, view)
        return unless render_me?(builder, view)

        options = eval_property(:options, builder, view)
        builder.input_field(self.name, options)
      end
    end
  end
end
