# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module Factory
      class ResponseFactory
        # rubocop:disable Layout/LineLength
        # @rbs (response: untyped, ?status_code: Integer, ?id: String, ?data: Hash[Symbol, untyped] | Array[Hash[Symbol, untyped]], resource_name: String?) -> String?
        # rubocop:enable Layout/LineLength
        def self.create_response(response:, status_code: 200, id: '', data: [], resource_name: nil)
          payload = ::Presentation::Controller::ControllerPayLoad.new(id: id, status_code: status_code, data: data)
          responder(response: response, payload: payload, resource_name: resource_name)
        end

        # rubocop:disable Layout/LineLength
        # @rbs (response: untyped, payload: ::Presentation::Controller::ControllerPayLoad, resource_name: String?) -> untyped
        # rubocop:enable Layout/LineLength
        def self.responder(response:, payload:, resource_name: nil)
          handler = success_responders(response: response, payload: payload,
                                       resource_name: resource_name)[payload.status_code]
          raise "Unsupported status code: #{payload.status_code}" unless handler

          handler.call
        end

        # rubocop:disable Layout/LineLength
        # @rbs (response: untyped, payload: ::Presentation::Controller::ControllerPayLoad, resource_name: String?) -> Hash[Integer, ^() -> untyped]
        # rubocop:enable Layout/LineLength
        def self.success_responders(response: nil, payload: nil, resource_name: nil)
          {
            200 => lambda {
              ::Presentation::Response::Factory::OkResponder.build_responder(response: response, payload: payload)
            },
            201 => -> { build_created_responder(response: response, payload: payload, resource_name: resource_name) },
            204 => -> { ::Presentation::Response::Factory::NoContentResponder.build_responder(response: response, payload: payload) }
          }
        end

        # rubocop:disable Layout/LineLength
        # @rbs (payload: ::Presentation::Controller::ControllerPayLoad, response: untyped, resource_name: String?) -> untyped
        # rubocop:enable Layout/LineLength
        def self.build_created_responder(payload:, response: nil, resource_name: nil)
          ::Presentation::Response::Factory::CreatedResponder.build_responder(
            response: response,
            payload: payload,
            resource_name: resource_name || 'users'
          )
        end

        private_class_method :success_responders, :build_created_responder
      end
    end
  end
end
