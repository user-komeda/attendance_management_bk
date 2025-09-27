# frozen_string_literal: true

module Presentation
  module Request
    module User
      class UserBaseRequest < BaseRequest
        attr_reader :id, :first_name, :last_name, :email

        CREATE_INPUT_DTO = ::Application::Dto::User::CreateUserInputDto.freeze
        UPDATE_INPUT_DTO = ::Application::Dto::User::UpdateUserInputDto.freeze
        CREATE_CONTRACT = ::Presentation::Request::Contract::CreateUserContract
        UPDATE_CONTRACT = ::Presentation::Request::Contract::UpdateUserContract
      end
    end
  end
end
