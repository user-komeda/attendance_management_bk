# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    class ControllerBase
      include ContainerHelper

      protected

      # Some frameworks provide `params`; declare its type for Steep
      # @rbs def params: () -> Hash[Symbol, untyped]

      # @rbs (Symbol key, *untyped args, **untyped kwargs) -> untyped
      def invoke_use_case(key, *args, **kwargs)
        use_case_key = self.class.const_get(:USE_CASE_CONTAINER)[key].key
        invoker = resolve(use_case_key)
        # @type var params: Hash[Symbol, untyped]
        params = if !UtilMethod.nil_or_empty?(args)
                   { args: args.first }
                 elsif !kwargs.empty?
                   kwargs
                 else
                   {}
                 end
        invoker.invoke(**params)
      end

      # @rbs (untyped request_payload, untyped request_class) -> untyped
      def build_request(request_payload, request_class)
        base = self.class.const_get(:BASE_REQUEST)
        raise ArgumentError, "#{request_class} is not a valid User request class" unless request_class <= base

        request_class.build(params: request_payload)
      end
    end
  end
end
