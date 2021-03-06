module FormForms
  module Elements
    # This represents a single form field. Typically this is the most
    # low-level part of a form. You can either return a form element with the
    # help of the passed form builder or just return arbitrary html. The block
    # is executed in the scope of the view where the form is rendered. You can
    # use any helpers defined there.
    #
    # Note that you might need to mark your values as +html_safe+ to avoid
    # superfluous escaping in the view.
    #
    # Example:
    #
    #   my_form = Form.new() do |form|
    #     form.field(:subject) {|f| f.input :subject}
    #     form.field(:link) do |f|
    #       content_tag :p do
    #         content_tag(:a, :href => hint_path){ "This is a hint" }
    #       end
    #     end
    #     form.field(:hint, "This is a hint")
    #   end
    class Field < BaseElement
      def initialize(value=nil, &generator)
        self.generator (block_given? ? generator : value)
      end

      property :generator

      def render(builder, view)
        eval_property(:generator, builder, view)
      end
    end
  end
end
