module FormForms
  class FormRegistry
    class << self
      def [](name)
        forms[name.to_sym]
      end

      def []=(name, form)
        forms[name.to_sym] = form
      end

      def delete(name)
        forms.delete(name.to_sym)
      end

      def keys
        forms.keys
      end
    protected
      def forms
        @forms ||= {}
      end
    end
  end
end