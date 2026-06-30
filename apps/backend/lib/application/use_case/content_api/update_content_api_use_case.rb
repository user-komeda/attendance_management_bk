# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module ContentApi
      class UpdateContentApiUseCase < ContentApiBaseUseCase
        # @rbs (arg: ::Application::Dto::ContentApi::UpdateContentApiWithFieldsInputDto) -> ::Application::Dto::ContentApi::ContentApiWithFieldsDto
        def invoke(arg:)
          rom = resolve('db.config')
          rom.gateways[:default].transaction do
            execute_update(dto: arg)
          end
        end

        private

        # @rbs (dto: ::Application::Dto::ContentApi::UpdateContentApiWithFieldsInputDto) -> ::Application::Dto::ContentApi::ContentApiWithFieldsDto
        def execute_update(dto:)
          id = dto.id
          content_api_repository = resolve(CONTENT_API_REPOSITORY)
          content_api_service = resolve(CONTENT_API_SERVICE)

          content_api = find_content_api!(content_api_repository: content_api_repository, id: id)
          work_space = find_workspace!(content_api_service: content_api_service, work_space_id: dto.work_space_id)
          validate_content_api_workspace!(content_api: content_api, work_space: work_space)

          validate_update_uniqueness(content_api_service: content_api_service, content_api: content_api, dto: dto,
                                     id: id)

          updated_entity = build_updated_entity(content_api: content_api, dto: dto, id: id)
          result_entity = content_api_repository.update(content_api_entity: updated_entity)
          CONTENT_API_WITH_FIELDS_DTO.build(
            content_api_entity: result_entity,
            field_entities: result_entity.fields
          )
        end

        # @rbs (
        #   content_api_service: untyped,
        #   content_api: untyped,
        #   dto: ::Application::Dto::ContentApi::UpdateContentApiWithFieldsInputDto,
        #   id: String
        # ) -> void
        def validate_update_uniqueness(content_api_service:, content_api:, dto:, id:)
          if content_api_service.endpoint_exists_excluding?(
            work_space_id: content_api.work_space_id.value,
            endpoint: dto.content_api.endpoint,
            exclude_id: id
          )
            raise ::Application::Exception::DuplicatedException.new(message: 'endpoint already exists')
          end

          field_ids = dto.fields.map(&:field_id)
          return unless content_api_service.duplicate_field_id?(field_ids: field_ids)

          raise ::Application::Exception::DuplicatedException.new(message: 'field_id must be unique')
        end

        # @rbs (
        #   content_api: untyped,
        #   dto: ::Application::Dto::ContentApi::UpdateContentApiWithFieldsInputDto,
        #   id: String
        # ) -> ::Domain::Entity::ContentApi::ContentApiEntity
        def build_updated_entity(content_api:, dto:, id:)
          field_entities = dto.fields.map { |f| f.convert_to_entity(content_api_id: id) }
          ::Domain::Entity::ContentApi::ContentApiEntity.build_with_id(
            id: content_api.id.value,
            work_space_id: content_api.work_space_id.value,
            name: dto.content_api.name,
            endpoint: dto.content_api.endpoint,
            api_type: dto.content_api.api_type,
            fields: field_entities
          )
        end

        def find_content_api!(content_api_repository:, id:)
          content_api = content_api_repository.find_by_id(id: id)
          raise ::Application::Exception::NotFoundException.new(message: 'content_api not found') if content_api.nil?

          content_api
        end

        def find_workspace!(content_api_service:, work_space_id:)
          work_space = content_api_service.find_work_space_by_slug(slug: work_space_id)
          raise ::Application::Exception::NotFoundException.new(message: 'workspace not found') if work_space.nil?

          work_space
        end

        def validate_content_api_workspace!(content_api:, work_space:)
          return if content_api.work_space_id.value == work_space.id.value

          raise ::Application::Exception::NotFoundException.new(message: 'content_api not found')
        end
      end
    end
  end
end
