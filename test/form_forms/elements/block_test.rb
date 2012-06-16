require 'test_helper'

class FieldsetTest < ActionView::TestCase
  test "create a block" do
    with_form_for(@user) do |form|
      form.block(:red_box, :div, :class => "red_box") do |block|
        block.field(:credit_card) {|f| f.input :credit_card}
      end
    end

    assert_select 'form > div.red_box input.string#user_credit_card'
  end

  test "allow nesting of blocks" do
    with_form_for(@user) do |form|
      form.block(:main, :div, :id => 'main') do |outer|
        outer.fieldset(:payment, :id => "payment") do |inner|
          inner.legend "These are some fields"
          inner.field(:credit_card) {|f| f.input :credit_card}
        end

        outer.field(:name) {|f| f.input :name}
      end
    end

    assert_no_select 'fieldset#main > legend'
    assert_select 'form > div#main > div > input.string#user_name'

    assert_select 'form > div#main > fieldset#payment > legend', "These are some fields"
    assert_select 'form > div#main > fieldset#payment input.string#user_credit_card'
  end
end