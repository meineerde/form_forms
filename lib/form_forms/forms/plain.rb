module FormForms
  module Forms
    # The generic form for generating plain HTML without an actual form.
    # This class is only usable as a top-level form.
    class Plain < BaseForm
      allowed_sub_element :field
      allowed_sub_element :sub_form
      allowed_sub_element :block
      allowed_sub_element :fieldset

      # Render the form.
      # As we don't have an actual form, the builder (i.e. the object passed
      # as the first parameter to generator blocks of elements) is always nil.
      # This has to be taken into acount when creating elements.
      def render(view)
        view.capture do
          render_elements(nil, view)
        end
      end
    end
  end
end