module FormForms
  class FormRegistryTest < ActionView::TestCase
    test "set, get, and delete registered form" do
      assert_nil FormRegistry['foo']

      form = Forms::Form.new{}
      FormRegistry['foo'] = form
      assert_equal FormRegistry['foo'], form

      FormRegistry.delete('foo')
      assert_nil FormRegistry['foo']
    end
  end
end