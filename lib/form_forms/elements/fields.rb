module FormForms
  module Elements
    # The generic form for building a simple_form..
    #
    # This class is only usable as a top-level form as it generates its own
    # form builder object
    class Fields < BaseElement
      allowed_sub_element :field
      allowed_sub_element :fieldset
      allowed_sub_element :fields
      allowed_sub_element :table_fields

      def initialize(form_args={})
        @fields_for = proc{|f| nil}
        @form_args = form_args
        super
      end

      def for(fields_for=nil, &generator)
        if block_given?
          @fields_for = generator
        else
          @fields_for = proc{|f| fields_for}
        end
      end

      def for(*args)
        @fields_for = args if args.present?
        @fields_for
      end


      def render(model, view)
        attr = view.instance_exec(builder, &@fields_for)

        view.simple_fields_for(attr, @form_args) do |builder|
          render_elements(builder, controller)
        end
      end
    end
  end
end