# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Service
    module User
      class UserBaseService < BaseService
        KEY = Constant::ContainerKey::DomainRepositoryKey::DOMAIN_REPOSITORY[:user].key.freeze
      end
    end
  end
end
