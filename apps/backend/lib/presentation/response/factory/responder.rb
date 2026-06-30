# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module Factory
      class Responder
        # @rbs (
        #   response: untyped,
        #   payload: ::Presentation::Controller::ControllerPayLoad,
        #   resource_name: String?
        # ) -> untyped
        def self.build_responder(response:, payload:, resource_name: nil)
          # :nocov:
          raise NotImplementedError
          # :nocov:
        end
      end
    end
  end
end
