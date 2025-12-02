# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module User
      class CreateUserRequest < UserBaseRequest
        # @rbs (Hash[Symbol, untyped] params) -> void
        def initialize(params)
          super()
          @first_name = params[:first_name]
          @last_name = params[:last_name]
          @email = params[:email]
        end

        # @rbs () -> ::Application::Dto::User::CreateUserInputDto
        def convert_to_dto
          CREATE_INPUT_DTO.new(
            first_name: @first_name,
            last_name: @last_name,
            email: @email
          )
        end

        # @rbs (Hash[Symbol, untyped] params) -> CreateUserRequest
        def self.build(params)
          validate(params)
          CreateUserRequest.new(params)
        end

        class << self
          private

          # @rbs (Hash[Symbol, untyped] params) -> void
          def validate(params)
            result = UserBaseRequest::CREATE_CONTRACT.new.call(params)
            return unless result.failure?

            raise ::Presentation::Exception::BadRequestException.new(message: result.errors.to_h.to_json)
          end
        end
      end
    end
  end
end
