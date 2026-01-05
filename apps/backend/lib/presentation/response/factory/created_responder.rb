# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module Factory
      class CreatedResponder < Responder
        # rubocop:disable all
        # @rbs (response: untyped, payload: ::Presentation::Controller::ControllerPayLoad,resource_name: String) -> untyped
        # rubocop:enable all
        def self.build_responder(response:, payload:, resource_name:)
          response.status = payload.status_code
          response['Content-Type'] = 'application/json'
          response['Location'] = "http://localhost:8080/#{resource_name}/#{payload.id}"
          payload.data.to_json
        end
      end
    end
  end
end
