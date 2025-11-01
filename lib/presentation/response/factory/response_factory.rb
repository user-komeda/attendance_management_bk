# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module Factory
      class ResponseFactory
        # @rbs (response: untyped, ?status_code: Integer, ?id: String, ?data: Hash[Symbol, untyped] | Array[Hash[Symbol, untyped]]) -> String?
        def self.create_response(response:, status_code: 200, id: '', data: [])
          payload = ::Presentation::Controller::ControllerPayLoad.new(id: id, status_code: status_code, data: data)
          responder(response: response, payload: payload)
        end

        # @rbs (response: untyped, payload: ::Presentation::Controller::ControllerPayLoad) -> untyped
        def self.responder(response:, payload:)
          success_status_code = {
            200 => lambda {
              ::Presentation::Response::Factory::OkResponder.build_responder(response: response, payload: payload)
            },
            201 => lambda {
              ::Presentation::Response::Factory::CreatedResponder.build_responder(response: response, payload: payload)
            },
            204 => lambda {
              ::Presentation::Response::Factory::NoContentResponder.build_responder(response: response,
                                                                                    payload: payload)
            }
          }

          handler = success_status_code[payload.status_code]
          raise "Unsupported status code: #{payload.status_code}" unless handler

          handler.call
        end
      end
    end
  end
end