# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    class ControllerBase
      include ContainerHelper

      protected

      # Some frameworks provide `params`; declare its type for Steep
      # @rbs def params: () -> Hash[Symbol, untyped]

      # @rbs (Symbol key, *untyped args) -> untyped
      def invoke_use_case(key, *args)
        raise NotImplementedError, "#{self.class} must implement #invoke_use_case"
      end

      # @rbs (untyped request_payload, untyped class_name) -> untyped
      def build_request(request_payload, class_name)
        raise NotImplementedError, "#{self.class} must implement #build_request"
      end
    end
  end
end
