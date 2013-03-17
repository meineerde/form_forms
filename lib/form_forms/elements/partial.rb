module FormForms
  module Elements
    class Partial < Field
      def render(builder, view)
        partial = eval_property(:generator, builder, view)

        # If the generator returns something falsey, we don't render anything
        # This can be used for conditional rendering
        return unless partial
        # retrueve the partial form from the registry of necessary
        partial = FormForms::FormRegistry[partial] unless partial.is_a? FormForms::Forms::PartialForm

        partial.render(builder, view)
      end
    end
  end
end
