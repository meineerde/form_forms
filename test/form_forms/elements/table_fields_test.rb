require File.expand_path('../../../test_helper', __FILE__)

class TableFieldsTest < ActionView::TestCase
  test "render a sub-form as a table" do
    with_form_for(@user) do |form|
      form.field(:name) {|f| f.input :name}

      form.table_fields(:companies, :companies) do |table|
        table.header do |header|
          header.field(:name) {|f| "Name" }
          header.field(:location) {|f| "Location" }
          header.field(:description) {|f| "Description" }
          header.field(:actions, :class => "actions") {|f| "Actions" }
        end

        table.row_args({:class => "nested-fields"})

        table.field(:name) {|f| f.input :name}
        table.field(:location) {|f| f.input :location}
        table.field(:description) {|f| f.input :description}
        table.sub_form(:actions) do |actions|
          actions.field(:delete) {|f| content_tag(:a, :href => "#") { "Delete" } }
          actions.field(:id) {|f| f.hidden_field :id }
        end
      end
    end

    assert_select 'form > div:nth-of-type(2) > input.string#user_name'

    # Header rendered correctly?
    assert_select 'form > table'
    assert_select 'table > thead > tr > th:nth-of-type(1)', 'Name'
    assert_select 'table > thead > tr > th:nth-of-type(2)', 'Location'
    assert_select 'table > thead > tr > th:nth-of-type(4).actions', 'Actions'

    # All rows fully rendered
    (1..3).each do |i|
      assert_select "table > tbody > tr:nth-of-type(#{i}) > td:nth-of-type(1) input.string#user_companies_attributes_#{i-1}_name[value='Company #{i}']"
      assert_select "table > tbody > tr:nth-of-type(#{i}) > td:nth-of-type(2) textarea.text#user_companies_attributes_#{i-1}_location", Company.all[i-1].location
      assert_select "table > tbody > tr:nth-of-type(#{i}) > td:nth-of-type(3) textarea.text#user_companies_attributes_#{i-1}_description", ""

      assert_select "table > tbody > tr:nth-of-type(#{i}) > td:nth-of-type(4) a[href='#']", "Delete"
      assert_select "table > tbody > tr:nth-of-type(#{i}) > td:nth-of-type(4) input#user_companies_attributes_#{i-1}_id[type=hidden][value=#{i}]"
    end

    # No more rows than expected
    assert_no_select 'table > tbody > tr:nth-of-type(4)'
  end
end