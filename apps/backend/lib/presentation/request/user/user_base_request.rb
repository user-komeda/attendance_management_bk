# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module User
      class UserBaseRequest < BaseRequest
        # @rbs @id: String?
        # @rbs @first_name: String
        # @rbs @last_name: String
        # @rbs @email: String
        attr_reader :id, :first_name, :last_name, :email

        # @rbs CREATE_INPUT_DTO: ::Application::Dto::User::CreateUserInputDto
        CREATE_INPUT_DTO = ::Application::Dto::User::CreateUserInputDto.freeze
        # @rbs UPDATE_INPUT_DTO: ::Application::Dto::User::UpdateUserInputDto
        UPDATE_INPUT_DTO = ::Application::Dto::User::UpdateUserInputDto.freeze
        # @rbs CREATE_CONTRACT: ::Presentation::Request::Contract::CreateUserContract
        CREATE_CONTRACT = ::Presentation::Request::Contract::CreateUserContract
        # @rbs UPDATE_CONTRACT: ::Presentation::Request::Contract::UpdateUserContract
        UPDATE_CONTRACT = ::Presentation::Request::Contract::UpdateUserContract
      end
    end
  end
end
