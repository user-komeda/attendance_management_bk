# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module ContentApi
      class ContentApiBaseUseCase < BaseUseCase
        CONTENT_API_REPOSITORY = Constant::ContainerKey::DomainRepositoryKey::CONTENT_API_DOMAIN_REPOSITORY[:content_api]
                                 .key.freeze # : String
        CONTENT_API_DTO = Dto::ContentApi::ContentApiDto.freeze # : singleton(Dto::ContentApi::ContentApiDto)
        FIELD_DTO = Dto::ContentApi::FieldDto.freeze # : singleton(Dto::ContentApi::FieldDto)
        CONTENT_API_WITH_FIELDS_DTO = Dto::ContentApi::ContentApiWithFieldsDto.freeze # : singleton(Dto::ContentApi::ContentApiWithFieldsDto)
        CONTENT_API_SERVICE =
          Constant::ContainerKey::ServiceKey::CONTENT_API_SERVICE[:content_api].key.freeze # : String
      end
    end
  end
end
