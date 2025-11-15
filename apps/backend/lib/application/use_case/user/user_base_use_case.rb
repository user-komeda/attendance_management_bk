# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module User
      class UserBaseUseCase < BaseUseCase
        KEY = Constant::ContainerKey::DomainRepositoryKey::DOMAIN_REPOSITORY[:user].key.freeze
        SERVICE_KEY = Constant::ContainerKey::ServiceKey::SERVICE[:user].key.freeze
        USER_DTO = Application::Dto::User::UserDto.freeze
      end
    end
  end
end
