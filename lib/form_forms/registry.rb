require 'active_support/hash_with_indifferent_access'

module FormForms
  class Registry
    class << self
      def method_missing(method, *args, &block)
        if forms.respond_to?(method)
          forms.send(method, *args, &block)
        else
          super
        end
      end

    protected
      def forms
        @forms ||= HashWithIndifferentAccess.new
      end
    end
  end

  # Deprecated class
  class FormRegistry
    class << self
      def method_missing(method, *args, &block)
        ::ActiveSupport::Deprecation.warn("FormRegistry is deprecated and will be removed from FormForms in version 0.4.0", caller)
        Registry.send(method, *args, &block)
      end
    end
  end
end
