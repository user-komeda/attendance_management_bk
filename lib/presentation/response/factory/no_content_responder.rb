# frozen_string_literal: true

module Presentation
  module Response
    module Factory
      class NoContentResponder < Responder
        def self.build_responder(response:, payload:)
          response.status = payload.status_code
          return if ::UtilMethod.nil_or_empty(payload.id)

          response['ETag'] = payload.id
        end
      end
    end
  end
end
