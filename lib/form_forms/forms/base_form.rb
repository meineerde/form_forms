module FormForms
  module Forms
    # The generic top-levelform for building a simple_form..
    #
    # This class (and all its children) is only usable as a top-level form
    # as it generates its own form builder object which is passed to its
    # sub-elements on rendering
    class BaseForm < FormForms::Elements::BaseElement
      # +form_args+ are passed to the initializer of the form builder.
      # They can be used to override its defaults.
      def initialize(form_args = {})
        @form_args = form_args
        super
      end

      def render(model, view)
        view.form_for(model, @form_args) do |builder|
          render_elements(builder, controller)
        end
      end

      def self.register(name, form_args={}, &generator)
        ::FormForms::FormRegistry[name] = self.new(form_args, &generator)
      end
    end
  end
end