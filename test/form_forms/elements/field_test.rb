require 'test_helper'

class FieldTest < ActionView::TestCase
  test "render a simple_form field" do
    with_form_for(@user) do |form|
      form.field(:name) {|f| f.input :name}
      form.field(:description) {|f| f.input :description}
    end

    assert_select 'input.string#user_name'
    assert_select 'textarea.text#user_description'
  end

  test "render a custom field" do
    with_form_for(@user) do |form|
      form.field(:something) {|f| '<span id="foo">Something</span>'.html_safe}
    end

    assert_select 'span#foo', "Something"
  end

  test "escape unsafe output" do
    with_form_for(@user) do |form|
      form.field(:something) {|f| '<span id="foo">Something</span>'}
    end

    assert_no_select 'span#foo', 'Something'
    assert_select 'form', '&lt;span id=&quot;foo&quot;&gt;Something&lt;/span&gt;'
  end

  test "allow the usage of view helpers" do
    with_form_for(@user) do |form|
      form.field(:something) {|f| content_tag(:span){"Something"}}
    end

    assert_select 'span', "Something"
  end

  test "allow appending elements" do
    with_form_for(@user) do |form|
      form.field(:name) {|f| f.input :name}
      form.field(:description) {|f| f.input :description}

      form.field_after(:name, :credit_card) {|f| f.input :credit_card}
    end

    # the first div in a form contains some hidden fields
    assert_select 'form > div:nth-of-type(2) > input.string#user_name'
    assert_select 'form > div:nth-of-type(3) > input.string#user_credit_card'
    assert_select 'form > div:nth-of-type(4) > textarea.text#user_description'
  end

  test "allow prepending elements" do
    with_form_for(@user) do |form|
      form.field(:name) {|f| f.input :name}
      form.field(:description) {|f| f.input :description}

      form.field_before(:name, :credit_card) {|f| f.input :credit_card}
    end

    # the first div in a form contains some hidden fields
    assert_select 'form > div:nth-of-type(2) > input.string#user_credit_card'
    assert_select 'form > div:nth-of-type(3) > input.string#user_name'
    assert_select 'form > div:nth-of-type(4) > textarea.text#user_description'
  end

  test "delete field" do
    with_form_for(@user) do |form|
      form.field(:name) {|f| f.input :name}
      form.field(:description) {|f| f.input :description}

      form.delete(:description)
    end

    assert_select 'input.string#user_name'
    assert_no_select 'textarea.text#user_description'
  end
end