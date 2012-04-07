require 'test_helper'

class FieldTest < ActionView::TestCase
  setup do
    @form = FormForms::Forms::Form.new do |form|
      form.field(:name) {|f| f.input :name}
      form.field(:description) {|f| f.input :description}
      form.field(:something) {|f| '<span id="something">Something</span>'.html_safe}
    end
  end

  test "renders a simple_form field" do
    concat @form.render(@user, self)
    assert_select 'input.string#user_name'
    assert_select 'textarea.text#user_description'

    assert_select 'span#something'
  end
end