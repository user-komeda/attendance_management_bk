# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module ContentApi
      class GetDetailContentApiUseCase < ContentApiBaseUseCase
        # @rbs (arg: String) -> ::Application::Dto::ContentApi::ContentApiWithFieldsDto
        def invoke(arg:)
          content_api_repository = resolve(CONTENT_API_REPOSITORY)
          content_api_entity = content_api_repository.find_by_id(id: arg)
          if content_api_entity.nil?
            raise ::Application::Exception::NotFoundException.new(message: 'content_api not found')
          end

          CONTENT_API_WITH_FIELDS_DTO.build(
            content_api_entity: content_api_entity,
            field_entities: content_api_entity.fields
          )
        end
      end
    end
  end
end
