# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module Auth
      class SignupRequest < AuthBaseRequest
        # rubocop:disable all
        attr_reader :first_name, :last_name, :email, :password #: String
        # rubocop:enable all

        # @rbs (params: { first_name: String, last_name: String, email: String, password: String }) -> void
        def initialize(params:)
          super()
          @first_name = params[:first_name]
          @last_name = params[:last_name]
          @email = params[:email]
          @password = params[:password]
        end

        # @rbs () -> ::Application::Dto::Auth::SignupInputDto
        def convert_to_dto
          SIGNUP_INPUT_DTO.new(
            params: {
              first_name: @first_name,
              last_name: @last_name,
              email: @email,
              password: @password
            }
          )
        end

        # @rbs (params: { first_name: String, last_name: String, email: String, password: String }) -> SignupRequest
        def self.build(params:)
          validate(params: params)
          SignupRequest.new(params: params)
        end

        class << self
          private

          # @rbs (params: { first_name: String, last_name: String, email: String, password: String }) -> void
          def validate(params:)
            result = AuthBaseRequest::SIGNUP_CONTRACT.new.call(params)
            return unless result.failure?

            raise ::Presentation::Exception::BadRequestException.new(message: result.errors.to_h.to_json)
          end
        end
      end
    end
  end
end
