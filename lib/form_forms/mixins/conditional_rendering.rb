require 'active_support/concern'

module FormForms
  module Mixins
    module ConditionalRendering
      extend ActiveSupport::Concern

      included do
        property :if
        property :unless
      end

    protected
      def render_me?(builder, view)
        case
        when defined?(@if)
          eval_property(:if, builder, view)
        when defined?(@unless)
          !eval_property(:unless, builder, view)
        else
          true
        end
      end
    end
  end
end
