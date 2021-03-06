require 'test_helper'

class InputTest < ActionView::TestCase
  test "render a simple_form field" do
    with_form_for(@user) do |form|
      form.input(:name)
      form.input(:description)
    end

    assert_select 'input.string#user_name'
    assert_select 'textarea.text#user_description'
  end

  test "render a custom field" do
    with_form_for(@user) do |form|
      form.input(:name, :label => false, :error => false){ "Something" }
    end

    assert_no_select 'input.string#user_name'
    assert_select 'div.input.string', "Something"
  end

  test "can add input fields without explicit arguments" do
    name = nil
    form = with_form_for(@user) do |form|
      name = form.input(:name)
    end

    # The simple input fields gets successfully created
    assert_equal name, form.input(:name)
    assert_kind_of ::FormForms::Elements::Input, form.input(:name)

    # A new simple element can be created afterwards
    assert (not form.elements.include? :description)
    assert_kind_of ::FormForms::Elements::Input, form.input(:description)
    assert form.elements.include? :description

    # Elements that require an argument are not implicitly created
    assert_nil form.table_fields(:foo)
  end

  test "render conditionally with if" do
    with_form_for(@user) do |form|
      form.input(:name, :if => lambda{|f| false})
      form.input(:credit_card, :if => lambda{|f| true})
    end

    assert_no_select 'input.string#user_name'
    assert_select 'form > div:nth-of-type(2) > input.string#user_credit_card'
  end

  test "render conditionally with unless" do
    with_form_for(@user) do |form|
      form.input(:name, :unless => lambda{|f| true})
      form.input(:credit_card, :unless => lambda{|f| false})
    end

    assert_no_select 'input.string#user_name'
    assert_select 'form > div:nth-of-type(2) > input.string#user_credit_card'
  end
end
