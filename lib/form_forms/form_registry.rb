require 'active_support/hash_with_indifferent_access'

module FormForms
  class FormRegistry
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
end