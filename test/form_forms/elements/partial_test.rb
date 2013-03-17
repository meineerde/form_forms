require 'test_helper'

class PartialTest < ActionView::TestCase
  test "render partial from form" do
    credit_card = FormForms::Forms::PartialForm.new do |partial|
      partial.field(:credit_card) {|f| f.input :credit_card}
    end
    credit_limit = FormForms::Forms::PartialForm.new do |partial|
      partial.field(:credit_limit) {|f| f.input :credit_limit}
    end

    with_form_for(@user) do |form|
      form.field(:name) {|f| f.input :name}
      form.partial :credit_card, credit_card
      form.partial(:credit_limit){ credit_limit }
    end

    assert_select 'form > div:nth-of-type(2) > input.string#user_name'
    assert_select 'form > div:nth-of-type(3) > input.string#user_credit_card'
    assert_select 'form > div:nth-of-type(4) > input.decimal#user_credit_limit'
  end

  test "render partial from registry" do
    FormForms::Registry["sub_form_test/_credit_card"] = FormForms::Forms::PartialForm.new do |partial|
      partial.field(:credit_card) {|f| f.input :credit_card}
    end
    FormForms::Registry["sub_form_test/_credit_limit"] = FormForms::Forms::PartialForm.new do |partial|
      partial.field(:credit_limit) {|f| f.input :credit_limit}
    end

    with_form_for(@user) do |form|
      form.field(:name) {|f| f.input :name}
      form.partial(:credit_card, "sub_form_test/_credit_card")
      form.partial(:credit_limit){ "sub_form_test/_credit_limit" }
    end

    assert_select 'form > div:nth-of-type(2) > input.string#user_name'
    assert_select 'form > div:nth-of-type(3) > input.string#user_credit_card'
    assert_select 'form > div:nth-of-type(4) > input.decimal#user_credit_limit'

    # cleanup
    FormForms::Registry.delete("sub_form_test/_credit_card")
    FormForms::Registry.delete("sub_form_test/_credit_limit")
  end

  test "render nothing if partial is falsey" do
    with_form_for(@user) do |form|
      form.field(:name) {|f| f.input :name}
      form.partial(:param, nil)
      form.partial(:block){ nil }
    end

    assert_select 'form > div:nth-of-type(2) > input.string#user_name'
    assert_select 'form > div:last-child > input.string#user_name'
  end

  test "raise if partial can't be resolved" do
    assert_raises NoMethodError do
      with_form_for(@user) do |form|
        form.field(:name) {|f| f.input :name}
        form.partial(:credit_card, "sub_form_test/_missing")
      end
    end
  end

end
