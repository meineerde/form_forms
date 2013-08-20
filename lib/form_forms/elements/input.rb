module FormForms
  module Elements
    class Input < BaseElement
      def initialize(options={}, &input)
        self.options options
        self.input input if block_given?
      end

      property :options
      property :input

      def render(builder, view)
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
