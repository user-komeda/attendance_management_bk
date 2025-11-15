# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module Factory
      class Responder
        # @rbs (response: untyped, payload: ::Presentation::Controller::ControllerPayLoad) -> untyped
        def self.build_responder(response:, payload:)
          raise NotImplementedError
        end
      end
    end
  end
end
