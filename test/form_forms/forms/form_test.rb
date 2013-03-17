require 'test_helper'

module FormForms
  module Forms
    class FormTest < ActionView::TestCase
      test "register form" do
        assert_nil FormForms::Registry['form_test']

        form = Form.register('form_test'){}

        assert_equal FormForms::Registry['form_test'], form
      end
    end
  end
end
