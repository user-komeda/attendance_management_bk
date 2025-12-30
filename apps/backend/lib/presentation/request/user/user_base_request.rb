# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module User
      class UserBaseRequest < BaseRequest
        # rubocop:disable all
        attr_reader :id, :first_name, :last_name, :email #: String
        # rubocop:enable all

        CREATE_INPUT_DTO = ::Application::Dto::User::CreateUserInputDto.freeze
        UPDATE_INPUT_DTO = ::Application::Dto::User::UpdateUserInputDto.freeze
        CREATE_CONTRACT = ::Presentation::Request::Contract::User::CreateUserContract
        UPDATE_CONTRACT = ::Presentation::Request::Contract::User::UpdateUserContract
      end
    end
  end
end
