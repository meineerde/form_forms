module FormForms
  module Forms
    # The generic form for building a simple_form..
    #
    # This class is only usable as a top-level form as it generates its own
    # form builder object
    class Form < BaseForm
      allowed_sub_element :field
      allowed_sub_element :sub_form
      allowed_sub_element :block
      allowed_sub_element :fieldset
      allowed_sub_element :fields
      allowed_sub_element :partial
      allowed_sub_element :table_fields

      # Render the form.
      # Notice that forms receive an ActiveModel object as its first
      # parameter, unlike elements which receive the form builder which is
      # created by a form.
      def render(model, view)
        view.simple_form_for(model, self.args) do |builder|
          render_elements(builder, view)
        end
      end
    end
  end
end
