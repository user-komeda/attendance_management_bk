# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module ContentApi
      class CreateContentApiUseCase < ContentApiBaseUseCase
        # @rbs (arg: ::Application::Dto::ContentApi::CreateContentApiWithFieldsInputDto) -> ::Application::Dto::ContentApi::ContentApiWithFieldsDto
        def invoke(arg:)
          with_transaction do
            execute_create(arg: arg)
          end
        end

        private

        # @rbs (arg: ::Application::Dto::ContentApi::CreateContentApiWithFieldsInputDto) -> ::Application::Dto::ContentApi::ContentApiWithFieldsDto
        def execute_create(arg:)
          content_api_repository = resolve(CONTENT_API_REPOSITORY)
          content_api_service = resolve(CONTENT_API_SERVICE)

          work_space = find_workspace_by_slug!(content_api_service: content_api_service,
                                               work_space_slug: arg.work_space_slug)

          content_api_entity = arg.convert_to_entity(work_space_id: work_space.id.value)

          validate_uniqueness(content_api_service: content_api_service, content_api_entity: content_api_entity)

          result_entity = content_api_repository.create(content_api_entity: content_api_entity)
          CONTENT_API_WITH_FIELDS_DTO.build(
            content_api_entity: result_entity,
            field_entities: result_entity.fields
          )
        end

        # @rbs (content_api_service: untyped, content_api_entity: untyped) -> void
        def validate_uniqueness(content_api_service:, content_api_entity:)
          validate_endpoint_uniqueness!(
            content_api_service: content_api_service,
            work_space_id: content_api_entity.work_space_id.value,
            endpoint: content_api_entity.endpoint,
            exclude_id: nil
          )
          validate_field_id_uniqueness!(
            content_api_service: content_api_service,
            field_ids: content_api_entity.fields.map(&:field_id)
          )
        end
      end
    end
  end
end
