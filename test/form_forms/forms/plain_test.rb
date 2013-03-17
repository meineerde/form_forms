require 'test_helper'

module FormForms
  module Forms
    class PlainTest < ActionView::TestCase
      test "render simple blocks" do
        assert_nil FormForms::Registry['plain_form']

        form = Plain.register('plain_form') do |form|
          form.block(:block1, :div) do |sub1|
            sub1.field(:f1){ content_tag :div, "Hello World" }
            sub1.field(:f2){ content_tag :p, "Hey Universe" }
          end
          form.field(:f3){content_tag :div, "Holger was here."}
        end
        assert_equal FormForms::Registry['plain_form'], form

        concat form.render(self)

        assert_select 'div > div', "Hello World"
        assert_select 'div > p', "Hey Universe"
        assert_select 'div', "Holger was here."
      end
    end
  end
end
