
# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module Factory
      class NoContentResponder < Responder
        # @rbs (response: untyped, payload: ::Presentation::Controller::ControllerPayLoad) -> void
        def self.build_responder(response:, payload:)
          response.status = payload.status_code
          return if ::UtilMethod.nil_or_empty(payload.id)

          response['ETag'] = payload.id
          nil
        end
      end
    end
  end
end