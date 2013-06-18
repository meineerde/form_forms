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
        res = true
        res = false if defined?(@if) && !eval_property(:if, builder, view)
        res = false if defined?(@unless) && eval_property(:unless, builder, view)
        res
      end
    end
  end
end
