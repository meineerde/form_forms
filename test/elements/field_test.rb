require 'test_helper'

class FieldTest < ActionView::TestCase
  class MockModel < ActiveRecordMock
    column :subject, :string
    column :description, :text
  end

  setup do
    @model = MockModel.new(:subject => "Subject", :description => "This is a text")
    @form = FormForms::Forms::Form.new do |form|
      form.field(:subject) {|f| f.input :subject}
      form.field(:description) {|f| f.input :description}
    end
  end

  test "renders the field" do
    @form.render(@model, self)
  end
end