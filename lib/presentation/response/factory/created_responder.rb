# frozen_string_literal: true

module Presentation
  module Response
    module Factory
      class CreatedResponder < Responder
        def self.build_responder(response:, payload:)
          response.status = payload.status_code
          response['Content-Type'] = 'application/json'
          response['Location'] = "http://localhost:8080/users/#{payload.id}"
          payload.data.to_json
        end
      end
    end
  end
end
