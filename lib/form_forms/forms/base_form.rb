module FormForms
  module Forms
    # The generic top-level form for building a simple_form..
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

      # Set the form_args. These are static as we don't have a form yet
      def args(form_args=nil)
        if form_args
          @form_args = form_args
        else
          @form_args
        end
      end

      # Render the form.
      # Notice that forms receive an ActiveModel object as its first
      # parameter, unlike elements which receive the form builder which is
      # created by a form.
      def render(model, view)
        view.simple_form_for(model, self.args) do |builder|
          render_elements(builder, view)
        end
      end

      def self.register(name, form_args={}, &generator)
        ::FormForms::FormRegistry[name] = self.new(form_args, &generator)
      end
    end
  end
end