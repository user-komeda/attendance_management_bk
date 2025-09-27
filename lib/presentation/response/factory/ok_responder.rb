# frozen_string_literal: true

module Presentation
  module Response
    module Factory
      class OkResponder
        def self.build_responder(response:, payload:)
          response.status = payload.status_code
          response['Content-Type'] = 'application/json'
          payload.data.to_json
        end
      end
    end
  end
end
