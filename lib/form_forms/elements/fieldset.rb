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

      generator_arg :args

      # Set the legend of the form. You can either set the legend directly by
      # passing a string or dynamically by passing a block. The block variant
      # behaves like exactly like a simple field.
      #
      #   fieldset = Fieldset.new(:class => "important") do |fs|
      #     fs.legend {|f| t(:my_legend) }
      #
      #     fieldset.field(:subject) {|f| f.input :subject}
      #   end
      generator_arg :legend

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