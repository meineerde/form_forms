require 'test_helper'

class FieldsetTest < ActionView::TestCase
  test "create a fieldset" do
    with_form_for(@user) do |form|
      form.fieldset(:payment, :id => "payment") do |fieldset|
        fieldset.legend "These are some fields"
        fieldset.field(:credit_card) {|f| f.input :credit_card}
      end
    end

    assert_select 'form > fieldset#payment legend', "These are some fields"
    assert_select 'form > fieldset#payment input.string#user_credit_card'
  end

  test "allow nesting of fieldsets" do
    with_form_for(@user) do |form|
      form.fieldset(:main, :id => 'main') do |outer|
        outer.fieldset(:payment, :id => "payment") do |inner|
          inner.legend "These are some fields"
          inner.field(:credit_card) {|f| f.input :credit_card}
        end

        outer.field(:name) {|f| f.input :name}
      end
    end

    assert_no_select 'fieldset#main > legend'
    assert_select 'form > fieldset#main > div > input.string#user_name'

    assert_select 'form > fieldset#main > fieldset#payment > legend', "These are some fields"
    assert_select 'form > fieldset#main > fieldset#payment input.string#user_credit_card'
  end

  test "dynamically set args and legend" do
    with_form_for(@user) do |form|
      form.fieldset(:main) do |fieldset|
        # static syntax
        fieldset.args :id => 'main'
        fieldset.legend "These are some fields"
      end

      form.fieldset(:block) do |fieldset|
        # dynamic block syntax
        fieldset.args{|f| {:id => 'block'} }
        fieldset.legend{|f| "This is a #{f.object.class.name.underscore}"}
      end
    end

    assert_select 'form > fieldset#main > legend', 'These are some fields'
    assert_select 'form > fieldset#block > legend', 'This is a user'
  end
end