require 'test_helper'

class InputTest < ActionView::TestCase
  test "render a custom field" do
    with_form_for(@user) do |form|
      form.input(:name, :label => false, :error => false){ "Something" }
    end

    assert_no_select 'input.string#user_name'
    assert_select 'div.input.string', "Something"
  end
end
