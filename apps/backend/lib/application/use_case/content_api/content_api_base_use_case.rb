# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module ContentApi
      class ContentApiBaseUseCase < BaseUseCase
        # Base utilities shared across Content API use cases.
        CONTENT_API_REPOSITORY = Constant::ContainerKey::DomainRepositoryKey::CONTENT_API_DOMAIN_REPOSITORY[:content_api]
                                 .key.freeze # : String
        CONTENT_API_DTO = Dto::ContentApi::ContentApiDto.freeze # : singleton(Dto::ContentApi::ContentApiDto)
        FIELD_DTO = Dto::ContentApi::FieldDto.freeze # : singleton(Dto::ContentApi::FieldDto)
        CONTENT_API_WITH_FIELDS_DTO = Dto::ContentApi::ContentApiWithFieldsDto.freeze # : singleton(Dto::ContentApi::ContentApiWithFieldsDto)
        CONTENT_API_SERVICE =
          Constant::ContainerKey::ServiceKey::CONTENT_API_SERVICE[:content_api].key.freeze # : String

        private

        # @rbs () { () -> untyped } -> untyped
        def with_transaction(&)
          rom = resolve('db.config')
          rom.gateways[:default].transaction(&)
        end

        # @rbs (content_api_repository: untyped, id: String) -> untyped
        def find_content_api(content_api_repository:, id:)
          find_content_api!(content_api_repository: content_api_repository, id: id)
        end

        # @rbs (content_api_repository: untyped, id: String) -> untyped
        def find_content_api!(content_api_repository:, id:)
          content_api = content_api_repository.find_by_id(id: id)
          ensure_present!(value: content_api, message: 'content_api not found')
        end

        # @rbs (content_api_service: untyped, work_space_slug: String) -> untyped
        def find_workspace_by_slug(content_api_service:, work_space_slug:)
          find_workspace_by_slug!(content_api_service: content_api_service, work_space_slug: work_space_slug)
        end

        # @rbs (content_api_service: untyped, work_space_slug: String) -> untyped
        def find_workspace_by_slug!(content_api_service:, work_space_slug:)
          work_space = content_api_service.find_work_space_by_slug(slug: work_space_slug)
          ensure_present!(value: work_space, message: 'workspace not found')
        end

        # @rbs (content_api_service: untyped, work_space_id: String, endpoint: String, exclude_id: String?) -> void
        def validate_endpoint_uniqueness(content_api_service:, work_space_id:, endpoint:, exclude_id: nil)
          validate_endpoint_uniqueness!(
            content_api_service: content_api_service,
            work_space_id: work_space_id,
            endpoint: endpoint,
            exclude_id: exclude_id
          )
        end

        # @rbs (content_api_service: untyped, work_space_id: String, endpoint: String, exclude_id: String?) -> void
        def validate_endpoint_uniqueness!(content_api_service:, work_space_id:, endpoint:, exclude_id: nil)
          endpoint_exists = endpoint_exists?(
            content_api_service: content_api_service,
            work_space_id: work_space_id,
            endpoint: endpoint,
            exclude_id: exclude_id
          )

          return unless endpoint_exists

          raise ::Application::Exception::DuplicatedException.new(message: 'endpoint already exists')
        end

        # @rbs (content_api_service: untyped, field_ids: Array[String]) -> void
        def validate_field_id_uniqueness(content_api_service:, field_ids:)
          validate_field_id_uniqueness!(content_api_service: content_api_service, field_ids: field_ids)
        end

        # @rbs (content_api_service: untyped, field_ids: Array[String]) -> void
        def validate_field_id_uniqueness!(content_api_service:, field_ids:)
          return unless content_api_service.duplicate_field_id?(field_ids: field_ids)

          raise ::Application::Exception::DuplicatedException.new(message: 'field_id must be unique')
        end

        # @rbs (content_api: untyped, work_space: untyped) -> void
        def validate_content_api_workspace(content_api:, work_space:)
          validate_content_api_workspace!(content_api: content_api, work_space: work_space)
        end

        # @rbs (content_api: untyped, work_space: untyped) -> void
        def validate_content_api_workspace!(content_api:, work_space:)
          return if content_api.work_space_id.value == work_space.id.value

          raise ::Application::Exception::NotFoundException.new(message: 'content_api not found')
        end

        # @rbs (content_api_service: untyped, work_space_id: String, endpoint: String, exclude_id: String?) -> bool
        def endpoint_exists?(content_api_service:, work_space_id:, endpoint:, exclude_id:)
          unless exclude_id
            return content_api_service.endpoint_exists?(work_space_id: work_space_id,
                                                        endpoint: endpoint)
          end

          content_api_service.endpoint_exists_excluding?(work_space_id: work_space_id, endpoint: endpoint,
                                                         exclude_id: exclude_id)
        end

        # @rbs (value: untyped, message: String) -> untyped
        def ensure_present(value:, message:)
          ensure_present!(value: value, message: message)
        end

        # @rbs (value: untyped, message: String) -> untyped
        def ensure_present!(value:, message:)
          value || raise(::Application::Exception::NotFoundException.new(message: message))
        end
      end
    end
  end
end
