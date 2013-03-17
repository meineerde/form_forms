module FormForms
  module Forms
    # This class is only usable as a mixin (or partial) into other forms.
    # You can reference it using the partial element (FormForms::Elements::Partial)
    class PartialForm < Form
      # Render the form without creating a new form builder.
      def render(builder, view)
        render_elements(builder, view)
      end
    end
  end
end
