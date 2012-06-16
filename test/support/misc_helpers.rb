module MiscHelpers
  def assert_no_select(selector, value = nil)
    assert_select(selector, :text => value, :count => 0)
  end

  def with_form_for(object, *args, &block)
    form = FormForms::Forms::Form.new(*args, &(block || proc {}))
    @rendered = form.render(object, self)
    concat @rendered
  end

  def rendered
    @rendered
  end
end