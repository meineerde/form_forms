module FormForms
  module Forms
    # The generic form for building a simple_form..
    #
    # This class is only usable as a top-level form as it generates its own
    # form builder object
    class Form < BaseForm
      allowed_sub_element :field
      allowed_sub_element :block
      allowed_sub_element :fieldset
      allowed_sub_element :fields
      allowed_sub_element :table_fields
    end
  end
end