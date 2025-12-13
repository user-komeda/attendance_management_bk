# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module Auth
      class AuthBaseUseCase < BaseUseCase
        AUTH_REPOSITORY_KEY = Constant::ContainerKey::DomainRepositoryKey::AUTH_DOMAIN_REPOSITORY[:auth].key.freeze
        USER_REPOSITORY_KEY = Constant::ContainerKey::DomainRepositoryKey::USER_DOMAIN_REPOSITORY[:user].key.freeze
        SERVICE_KEY = Constant::ContainerKey::ServiceKey::AUTH_SERVICE[:auth].key.freeze
        UserEntity = ::Domain::Entity::User::UserEntity.freeze
        AuthUserEntity = ::Domain::Entity::Auth::AuthUserEntity.freeze
        AUTH_OUTPUT_DTO = Application::Dto::Auth::AuthOutputDto.freeze
      end
    end
  end
end
