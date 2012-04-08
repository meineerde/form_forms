module FormForms
  module Elements
    class Fieldset < BaseElement
      allowed_sub_element :field
      allowed_sub_element :fieldset
      allowed_sub_element :fields
      allowed_sub_element :table_fields

      def initialize(fieldset_args = {})
        @legend = nil
        @fieldset_args = proc{|f| fieldset_args}
        super
      end

      def args(fieldset_args={}, &generator)
        if block_given?
          @fieldset_args = generator
        else
          @fieldset_args = proc{|f| fieldset_args}
        end
      end

      # Set the legend of the form. You can either set the legend directly by
      # passing a string or dynamically by passing a block. The block variant
      # behaves like exactly like a simple field.
      #
      #   fieldset = Fieldset.new(:class => "important") do |fs|
      #     fs.legend {|f| t(:my_legend) }
      #
      #     fieldset.field(:subject) {|f| f.input :subject}
      #   end
      def legend(legend=nil, &generator)
        if block_given?
          @legend = generator
        else
          @legend = proc{|f| legend}
        end
      end

      # Generate a fielset with a legend
      def render(builder, view)
        view.content_tag :fieldset, view.instance_exec(builder, &@fieldset_args) do
          buf = ActiveSupport::SafeBuffer.new
          buf << view.content_tag(:legend, view.instance_exec(builder, &@legend)) unless @legend.nil?
          buf << super
          buf
        end
      end
    end
  end
end