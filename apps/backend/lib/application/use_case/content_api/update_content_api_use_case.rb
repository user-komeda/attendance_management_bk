# frozen_string_literal: true

# rbs_inline: enabled

require_relative 'update_content_api_context'

module Application
  module UseCase
    module ContentApi
      class UpdateContentApiUseCase < ContentApiBaseUseCase
        # @rbs (arg: ::Application::Dto::ContentApi::UpdateContentApiWithFieldsInputDto) -> ::Application::Dto::ContentApi::ContentApiWithFieldsDto
        def invoke(arg:)
          with_transaction do
            execute_update(dto: arg)
          end
        end

        private

        # @rbs (dto: ::Application::Dto::ContentApi::UpdateContentApiWithFieldsInputDto) -> ::Application::Dto::ContentApi::ContentApiWithFieldsDto
        def execute_update(dto:)
          context = build_update_context(dto: dto)
          validate_update_context!(dto: dto, context: context)
          update_and_build_response(context: context)
        end

        # @rbs (dto: ::Application::Dto::ContentApi::UpdateContentApiWithFieldsInputDto) -> ::Application::UseCase::ContentApi::UpdateContentApiContext
        def build_update_context(dto:)
          id = dto.id

          UpdateContentApiContext.new(
            id: id,
            content_api: find_content_api!(content_api_repository: content_api_repository, id: id),
            content_api_dto: dto.content_api,
            field_entities: dto.fields.map { |field| field.convert_to_entity(content_api_id: id) }
          )
        end

        # rubocop:disable all
        # @rbs (dto: ::Application::Dto::ContentApi::UpdateContentApiWithFieldsInputDto, context: ::Application::UseCase::ContentApi::UpdateContentApiContext) -> void
        # rubocop:enable all
        def validate_update_context!(dto:, context:)
          validate_workspace(content_api_service: content_api_service, content_api: context.content_api,
                             work_space_id: dto.work_space_id)
          validate_update_uniqueness(content_api_service: content_api_service, content_api: context.content_api,
                                     dto: dto, id: context.id)
        end

        # @rbs (context: ::Application::UseCase::ContentApi::UpdateContentApiContext) -> ::Application::Dto::ContentApi::ContentApiWithFieldsDto
        def update_and_build_response(context:)
          updated_entity = build_updated_entity(content_api: context.content_api, id: context.id,
                                                content_api_dto: context.content_api_dto,
                                                field_entities: context.field_entities)
          result_entity = content_api_repository.update(content_api_entity: updated_entity)
          CONTENT_API_WITH_FIELDS_DTO.build(content_api_entity: result_entity, field_entities: result_entity.fields)
        end

        # @rbs (content_api_service: untyped, content_api: untyped, dto: untyped, id: String) -> void
        def validate_update_uniqueness(content_api_service:, content_api:, dto:, id:)
          content_api_dto = dto.content_api

          validate_endpoint_uniqueness!(
            content_api_service: content_api_service,
            work_space_id: content_api.work_space_id.value,
            endpoint: content_api_dto.endpoint,
            exclude_id: id
          )
          validate_field_id_uniqueness!(
            content_api_service: content_api_service,
            field_ids: dto.fields.map(&:field_id)
          )
        end

        # @rbs (content_api: untyped, id: String, content_api_dto: untyped, field_entities: Array[untyped]) -> ::Domain::Entity::ContentApi::ContentApiEntity
        def build_updated_entity(content_api:, id:, content_api_dto:, field_entities:)
          ::Domain::Entity::ContentApi::ContentApiEntity.build_with_id(
            id: id,
            work_space_id: content_api.work_space_id.value,
            name: content_api_dto.name,
            endpoint: content_api_dto.endpoint,
            api_type: content_api_dto.api_type,
            fields: field_entities
          )
        end

        # @rbs () -> untyped
        def content_api_repository
          @content_api_repository ||= resolve(CONTENT_API_REPOSITORY)
        end

        # @rbs () -> untyped
        def content_api_service
          @content_api_service ||= resolve(CONTENT_API_SERVICE)
        end

        # @rbs (content_api_service: untyped, content_api: untyped, work_space_id: String) -> void
        def validate_workspace(content_api_service:, content_api:, work_space_id:)
          validate_workspace!(content_api_service: content_api_service, content_api: content_api,
                              work_space_id: work_space_id)
        end

        # @rbs (content_api_service: untyped, content_api: untyped, work_space_id: String) -> void
        def validate_workspace!(content_api_service:, content_api:, work_space_id:)
          work_space = find_workspace_by_slug!(content_api_service: content_api_service, work_space_slug: work_space_id)
          validate_content_api_workspace!(content_api: content_api, work_space: work_space)
        end
      end
    end
  end
end
