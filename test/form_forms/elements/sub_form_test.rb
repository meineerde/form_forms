require 'test_helper'

class SubFormTest < ActionView::TestCase
  test "create a subform" do
    with_form_for(@user) do |form|
      form.field(:name) {|f| f.input :name}

      form.sub_form(:credit) do |block|
        block.field(:credit_card) {|f| f.input :credit_card}
        block.field(:credit_limit) {|f| f.input :credit_limit}
      end
    end

    assert_select 'form > div:nth-of-type(2) > input.string#user_name'
    assert_select 'form > div:nth-of-type(3) > input.string#user_credit_card'
    assert_select 'form > div:nth-of-type(4) > input.decimal#user_credit_limit'
  end
end