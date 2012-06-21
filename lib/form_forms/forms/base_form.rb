module FormForms
  module Forms
    # The generic top-level form for building a simple_form..
    class BaseForm < FormForms::Elements::BaseElement
      # +form_args+ are passed to the initializer of the form builder.
      # They can be used to override its defaults.
      def initialize(form_args = {})
        @form_args = form_args
        super
      end

      # Set the form_args. These are static as we don't have a form yet
      def args(form_args=nil)
        if form_args
          @form_args = form_args
        else
          @form_args
        end
      end

      # Render the form.
      #
      # This method needs to be overridden in a child class different
      # concrete form types recieve different parameters for render
      def render(*)
        raise NotImplementedError.new("Implement a render function in a subclass")
      end

      def self.register(name, form_args={}, &generator)
        ::FormForms::FormRegistry[name] = self.new(form_args, &generator)
      end
    end
  end
end