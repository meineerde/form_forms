require 'test_helper'

module FormForms
  class RegistryTest < ActionView::TestCase
    test "set, get, and delete registered form" do
      assert_nil Registry['foo']
      assert_nil Registry[:foo]

      form = Forms::Form.new{}
      Registry['foo'] = form
      assert_equal Registry['foo'], form
      assert_equal Registry[:foo], form
      assert Registry.keys.include?('foo'), "Expected FormRegistry.keys to include 'foo'"

      Registry.delete('foo')
      assert_nil Registry['foo']
      assert_nil Registry[:foo]
    end
  end
end
