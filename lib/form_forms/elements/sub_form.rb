module FormForms
  module Elements
    class SubForm < BaseElement
      allowed_sub_element :field
      allowed_sub_element :sub_form
      allowed_sub_element :block
      allowed_sub_element :fieldset
      allowed_sub_element :fields
      allowed_sub_element :table_fields
    end
  end
end