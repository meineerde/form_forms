require File.expand_path('../../../test_helper', __FILE__)

class FieldsTest < ActionView::TestCase
  test "render a sub-form" do
    with_form_for(@user) do |form|
      form.field(:name) {|f| f.input :name}

      form.fields(:tags, :tags, :collection => Tag.all) do |tags|
        tags.field(:name) {|f| f.input :name}
      end
    end

    assert_select 'input.string#user_name'

    assert_select 'input.string#user_tags_attributes_0_name'
    assert_select 'input[type=hidden]#user_tags_attributes_0_id'

    assert_select 'input.string#user_tags_attributes_2_name'
    assert_select 'input[type=hidden]#user_tags_attributes_2_id'
  end

  test "pass the collection tag as a proc" do
    with_form_for(@user) do |form|
      form.field(:name) {|f| f.input :name}

      args = lambda{|f| {:collection => Tag.all} }
      form.fields(:tags, :tags, args) do |tags|
        tags.field(:name) {|f| f.input :name}
      end
    end

    assert_select 'input.string#user_name'

    assert_select 'input.string#user_tags_attributes_0_name'
    assert_select 'input[type=hidden]#user_tags_attributes_0_id'

    assert_select 'input.string#user_tags_attributes_2_name'
    assert_select 'input[type=hidden]#user_tags_attributes_2_id'
  end

  test "append field to sub-form" do
    with_form_for(@user) do |form|
      form.field(:name) {|f| f.input :name}

      form.fields(:tags, :tags, :collection => Tag.all) do |tags|
        tags.field(:name) {|f| f.input :name}
      end

      form.fields(:tags).field(:id) {|f| f.input :id}
    end

    assert_select 'input.string#user_name'

    assert_select 'input.string#user_tags_attributes_0_name'
    assert_select 'input.string#user_tags_attributes_0_id'
  end
end