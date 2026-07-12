# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module Factory
      class Responder
        ABSTRACT_MESSAGE = 'Subclasses must implement .build_responder'

        private_class_method :new

        # rubocop:disable all
        # @rbs (response: untyped, payload: ::Presentation::Controller::ControllerPayLoad, resource_name: String?) -> untyped
        # rubocop:enable all
        def self.build_responder(response:, payload:, resource_name: nil)
          validate_payload(payload: payload)
          touch_arguments(response: response, resource_name: resource_name)

          # :nocov:
          raise NotImplementedError, ABSTRACT_MESSAGE
          # :nocov:
        end

        class << self
          private

          # @rbs (payload: ::Presentation::Controller::ControllerPayLoad) -> void
          def validate_payload(payload:)
            validate_payload!(payload: payload)
          end

          # @rbs (response: untyped, resource_name: String?) -> void
          def touch_arguments(response:, resource_name:)
            response&.object_id
            resource_name&.to_s
          end

          # @rbs (payload: ::Presentation::Controller::ControllerPayLoad) -> void
          def validate_payload!(payload:)
            raise ArgumentError, 'payload is required' unless payload # :nocov:
          end
        end
      end
    end
  end
end
