# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Service
    module ContentApi
      class ContentApiBaseService < BaseService
        REPOSITORY_KEY = Constant::ContainerKey::DomainRepositoryKey::CONTENT_API_DOMAIN_REPOSITORY[:content_api].key.freeze
        WORK_SPACE_REPOSITORY_KEY = Constant::ContainerKey::DomainRepositoryKey::WORK_SPACE_DOMAIN_REPOSITORY[:work_space].key.freeze
      end
    end
  end
end
