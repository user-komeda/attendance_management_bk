# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module Factory
      class NoContentResponder < Responder
        # @rbs (response: untyped, payload: ::Presentation::Controller::ControllerPayLoad) -> untyped
        # rubocop:enable all
        def self.build_responder(response:, payload:)
          payload_id = payload.id

          apply_status(response: response, payload: payload)
          apply_etag(response: response, payload_id: payload_id)
          nil
        end

        class << self
          private

          # @rbs (response: untyped, payload: ::Presentation::Controller::ControllerPayLoad) -> void
          def apply_status(response:, payload:)
            response.status = payload.status_code
          end

          # @rbs (response: untyped, payload_id: String?) -> void
          def apply_etag(response:, payload_id:)
            return if ::UtilMethod.nil_or_empty?(payload_id)

            response['ETag'] = payload_id
          end
        end
      end
    end
  end
end
