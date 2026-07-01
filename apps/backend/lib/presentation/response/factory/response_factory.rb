# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module Factory
      class ResponseFactory
        # rubocop:disable all
        # @rbs (response: untyped, ?status_code: Integer, ?id: String, ?data: Hash[Symbol, untyped] | Array[Hash[Symbol, untyped]], resource_name: String?) -> String?
        # rubocop:enable all
        def self.create_response(response:, status_code: 200, id: '', data: [], resource_name: nil)
          payload = ::Presentation::Controller::ControllerPayLoad.new(id: id, status_code: status_code, data: data)
          responder(response: response, payload: payload, resource_name: resource_name)
        end

        # rubocop:disable all
        # @rbs (response: untyped, payload: ::Presentation::Controller::ControllerPayLoad, resource_name: String?) -> untyped
        # rubocop:enable all
        def self.responder(response:, payload:, resource_name: nil)
          status_code = payload.status_code

          case status_code
          when 200
            ::Presentation::Response::Factory::OkResponder.build_responder(response: response, payload: payload)
          when 201
            build_created_responder(response: response, payload: payload, resource_name: resource_name)
          when 204
            ::Presentation::Response::Factory::NoContentResponder.build_responder(response: response, payload: payload)
          else
            raise "Unsupported status code: #{status_code}"
          end
        end

        # rubocop:disable all
        # @rbs (payload: ::Presentation::Controller::ControllerPayLoad, response: untyped, resource_name: String?) -> untyped
        # rubocop:enable all
        def self.build_created_responder(payload:, response: nil, resource_name: nil)
          ::Presentation::Response::Factory::CreatedResponder.build_responder(
            response: response,
            payload: payload,
            resource_name: resource_name || 'users'
          )
        end

        private_class_method :build_created_responder
      end
    end
  end
end
