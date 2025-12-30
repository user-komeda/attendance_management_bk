# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module Auth
      class SigninRequest < AuthBaseRequest
        # rubocop:disable all
        attr_reader :email, :password #: String
        # rubocop:enable all

        # @rbs ({email: String, password: String }) -> void
        def initialize(params)
          super()
          @email = params[:email]
          @password = params[:password]
        end

        # @rbs () -> ::Application::Dto::Auth::SigninInputDto
        def convert_to_dto
          SIGNIN_INPUT_DTO.new(
            email: @email,
            password: @password
          )
        end

        class << self
          # @rbs ({email: String, password: String }) -> SigninRequest
          def build(params)
            validate(params)
            SigninRequest.new(params)
          end

          private

          # @rbs ({email: String, password: String }) -> void
          def validate(params)
            result = AuthBaseRequest::SIGNIN_CONTRACT.new.call(params)
            return unless result.failure?

            raise ::Presentation::Exception::BadRequestException.new(message: result.errors.to_h.to_json)
          end
        end
      end
    end
  end
end
