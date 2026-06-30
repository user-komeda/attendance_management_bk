# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Entity
    module ContentApi
      class ContentApiEntity < BaseEntity
        # @rbs!
        #   attr_reader id: String
        #   attr_reader work_space_id: String
        #   attr_reader name: String
        #   attr_reader endpoint: String
        #   attr_reader api_type: String
        attribute :id, ROM::Types::String
        attribute :work_space_id, ROM::Types::String
        attribute :name, ROM::Types::String
        attribute :endpoint, ROM::Types::String
        attribute :api_type, ROM::Types::String

        # @rbs () -> ::Domain::Entity::ContentApi::ContentApiEntity
        def to_domain
          ::Domain::Entity::ContentApi::ContentApiEntity.build_with_id(
            id: id,
            work_space_id: work_space_id,
            name: name,
            endpoint: endpoint,
            api_type: api_type
          )
        end

        # @rbs (struct: untyped) -> ::Domain::Entity::ContentApi::ContentApiEntity
        def self.struct_to_domain(struct:)
          new(
            id: struct.id,
            work_space_id: struct.work_space_id,
            name: struct.name,
            endpoint: struct.endpoint,
            api_type: struct.api_type
          ).to_domain
        end

        # @rbs (struct: untyped) -> ::Domain::Entity::ContentApi::ContentApiEntity
        def self.struct_to_domain_with_fields(struct:)
          fields = (struct.fields || []).map { |f| ::Infrastructure::Entity::ContentApi::FieldEntity.new(**f.to_h).to_domain }
          ::Domain::Entity::ContentApi::ContentApiEntity.build_with_id(
            id: struct.id,
            work_space_id: struct.work_space_id,
            name: struct.name,
            endpoint: struct.endpoint,
            api_type: struct.api_type,
            fields: fields
          )
        end

        # @rbs (content_api_entity: ::Domain::Entity::ContentApi::ContentApiEntity) -> ContentApiEntity
        def self.build_from_domain_entity(content_api_entity:)
          new(
            id: ::UtilMethod.nil_or_empty?(content_api_entity.id) ? SecureRandom.uuid : content_api_entity.id.value,
            work_space_id: content_api_entity.work_space_id.value,
            name: content_api_entity.name,
            endpoint: content_api_entity.endpoint,
            api_type: content_api_entity.api_type
          )
        end
      end
    end
  end
end
