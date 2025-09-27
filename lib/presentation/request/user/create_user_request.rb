# frozen_string_literal: true

module Presentation
  module Request
    module User
      class CreateUserRequest < UserBaseRequest
        def convert_to_dto
          CREATE_INPUT_DTO.new(
            first_name: @first_name,
            last_name: @last_name,
            email: @email
          )
        end

        def self.build(params)
          CreateUserRequest.validate(params)
          CreateUserRequest.new(params)
        end

        def self.validate(params)
          result = CREATE_CONTRACT.new.call(params)
          raise NotImplementedError if result.failure?
        end

        private

        def initialize(params)
          super()
          @first_name = params[:first_name]
          @last_name = params[:last_name]
          @email = params[:email]
        end
      end
    end
  end
end
