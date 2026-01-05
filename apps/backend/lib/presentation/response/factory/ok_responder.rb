# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module Factory
      class OkResponder < Responder
        # @rbs (response: untyped, payload: ::Presentation::Controller::ControllerPayLoad) -> String
        # rubocop:enable all
        def self.build_responder(response:, payload:)
          response.status = payload.status_code
          response['Content-Type'] = 'application/json'
          payload.data.to_json
        end
      end
    end
  end
end
