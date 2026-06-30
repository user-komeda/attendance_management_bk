# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module ContentApi
      class CreateContentApiUseCase < ContentApiBaseUseCase
        # @rbs (arg: ::Application::Dto::ContentApi::CreateContentApiWithFieldsInputDto) -> ::Application::Dto::ContentApi::ContentApiWithFieldsDto
        def invoke(arg:)
          rom = resolve('db.config')
          rom.gateways[:default].transaction do
            execute_create(arg: arg)
          end
        end

        private

        # @rbs (arg: ::Application::Dto::ContentApi::CreateContentApiWithFieldsInputDto) -> ::Application::Dto::ContentApi::ContentApiWithFieldsDto
        def execute_create(arg:)
          content_api_repository = resolve(CONTENT_API_REPOSITORY)
          content_api_service = resolve(CONTENT_API_SERVICE)

          work_space = content_api_service.find_work_space_by_slug(slug: arg.work_space_slug)
          raise ::Application::Exception::NotFoundException.new(message: 'workspace not found') if work_space.nil?

          content_api_entity = arg.convert_to_entity(work_space_id: work_space.id.value)

          validate_uniqueness(content_api_service: content_api_service, content_api_entity: content_api_entity)

          result_entity = content_api_repository.create(content_api_entity: content_api_entity)
          CONTENT_API_WITH_FIELDS_DTO.build(
            content_api_entity: result_entity,
            field_entities: result_entity.fields
          )
        end

        # @rbs (
        #   content_api_service: untyped,
        #   content_api_entity: ::Domain::Entity::ContentApi::ContentApiEntity
        # ) -> void
        def validate_uniqueness(content_api_service:, content_api_entity:)
          if content_api_service.endpoint_exists?(
            work_space_id: content_api_entity.work_space_id.value,
            endpoint: content_api_entity.endpoint
          )
            raise ::Application::Exception::DuplicatedException.new(message: 'endpoint already exists')
          end

          field_ids = content_api_entity.fields.map(&:field_id)
          return unless content_api_service.duplicate_field_id?(field_ids: field_ids)

          raise ::Application::Exception::DuplicatedException.new(message: 'field_id must be unique')
        end
      end
    end
  end
end
