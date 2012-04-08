module MiscHelpers
  def assert_no_select(selector, value = nil)
    assert_select(selector, :text => value, :count => 0)
  end

  def with_form_for(object, *args, &block)
    form = FormForms::Forms::Form.new(*args, &(block || proc {}))
    res = form.render(object, self)
    # p res
    concat res
  end
end