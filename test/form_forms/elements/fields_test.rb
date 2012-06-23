require File.expand_path('../../../test_helper', __FILE__)

class FieldsTest < ActionView::TestCase
  test "render a sub-form" do
    with_form_for(@user) do |form|
      form.field(:name) {|f| f.input :name}

      form.fields(:tags, :tags) do |tags|
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

      form.fields(:tags, :tags) do |tags|
        tags.field(:name) {|f| f.input :name}
      end

      form.fields(:tags).field(:id) {|f| f.input :id}
    end

    assert_select 'input.string#user_name'

    assert_select 'input.string#user_tags_attributes_0_name'
    assert_select 'input.string#user_tags_attributes_0_id'
  end

  test "render conditionally with if" do
    with_form_for(@user) do |form|
      form.fields(:tags1, :tags) do |tags|
        tags.if { false }

        tags.block(:block, :div, :class => 'tags1') do |block|
          block.field(:name) {|f| f.input :name, :id => "tags1"}
        end
      end

      form.fields(:tags2, :tags) do |tags|
        tags.if { true }

        tags.block(:block, :div, :class => 'tags2') do |block|
          block.field(:name) {|f| f.input :name, :id => "tags2"}
        end
      end
    end

    assert_no_select 'form > div.tags1'
    assert_select 'form > div.tags2 input.string#user_tags_attributes_0_name'
  end

  test "render conditionally with unless" do
    with_form_for(@user) do |form|
      form.fields(:tags1, :tags) do |tags|
        tags.unless { true }

        tags.block(:block, :div, :class => 'tags1') do |block|
          block.field(:name) {|f| f.input :name, :id => "tags1"}
        end
      end

      form.fields(:tags2, :tags) do |tags|
        tags.unless { false }

        tags.block(:block, :div, :class => 'tags2') do |block|
          block.field(:name) {|f| f.input :name, :id => "tags2"}
        end
      end
    end

    assert_no_select 'form > div.tags1'
    assert_select 'form > div.tags2 input.string#user_tags_attributes_0_name'
  end
end