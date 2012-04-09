module FormForms
  module Elements
    class Fieldset < BaseElement
      allowed_sub_element :field
      allowed_sub_element :fieldset
      allowed_sub_element :fields
      allowed_sub_element :table_fields

      def initialize(fieldset_args = {})
        self.legend{|f| nil}
        self.args{|f| fieldset_args}
        super
      end

      property :args
      property :legend

      # Generate a fielset with a legend
      def render(builder, view)
        legend = view.instance_exec(builder, &self.legend)

        view.content_tag :fieldset, view.instance_exec(builder, &self.args) do
          buf = ActiveSupport::SafeBuffer.new
          buf << view.content_tag(:legend, legend) unless legend.nil?
          buf << super
          buf
        end
      end
    end
  end
end