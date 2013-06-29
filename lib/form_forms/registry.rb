require 'active_support/hash_with_indifferent_access'

module FormForms
  class Registry < DelegateClass(ActiveSupport::HashWithIndifferentAccess)
    class << self
      def method_missing(method, *args, &block)
        if instance.respond_to?(method)
          instance.send(method, *args, &block)
        else
          super
        end
      end

      def respond_to?(*args)
        super || instance.respond_to?(*args)
      end

      def instance
        @instance ||= self.new
      end
    end

    def initialize
      @forms = HashWithIndifferentAccess.new
      # setup the delegation
      super(@forms)
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
