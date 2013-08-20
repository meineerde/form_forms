module FormForms
  module Elements
    class InputField < BaseElement
      def initialize(options={})
        self.options options
      end

      property :options

      def render(builder, view)
        options = eval_property(:options, builder, view)
        builder.input_field(self.name, options)
      end
    end
  end
end
