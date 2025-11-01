# frozen_string_literal: true

# rbs_inline: enabled


module Presentation
  module Request
    module User
      class UpdateUserRequest < UserBaseRequest
        # @rbs () -> ::Application::Dto::User::UpdateUserInputDto
        def convert_to_dto
          UPDATE_INPUT_DTO.new(
            id: @id,
            first_name: @first_name,
            last_name: @last_name,
            email: @email
          )
        end

        # @rbs (Hash[Symbol, untyped] params) -> UpdateUserRequest
        def self.build(params)
          UpdateUserRequest.validate(params)
          UpdateUserRequest.new(params)
        end

        # @rbs (Hash[Symbol, untyped] params) -> void
        def self.validate(params)
          result = UPDATE_CONTRACT.new.call(params)
          return unless result.failure?

          raise ::Presentation::Exception::BadRequestException.new(message: result.errors.to_h.to_json)
        end

        private

        # @rbs (Hash[Symbol, untyped] params) -> void
        def initialize(params)
          super()
          @id = params[:id]
          @first_name = params[:first_name]
          @last_name = params[:last_name]
          @email = params[:email]
        end
      end
    end
  end
end