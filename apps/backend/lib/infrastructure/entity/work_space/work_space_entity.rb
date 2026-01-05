# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Entity
    module WorkSpace
      class WorkSpaceEntity < BaseEntity
        # @rbs!
        #   attr_reader id: String
        #   attr_reader name: String
        #   attr_reader slug: String
        attribute :id, ROM::Types::String
        attribute :name, ROM::Types::String
        attribute :slug, ROM::Types::String

        # @rbs () -> ::Domain::Entity::WorkSpace::WorkSpaceEntity
        def to_domain
          ::Domain::Entity::WorkSpace::WorkSpaceEntity.build_with_id(id: id, name: name, slug: slug)
        end

        # @rbs (struct: untyped) -> ::Domain::Entity::WorkSpace::WorkSpaceEntity
        def self.struct_to_domain(struct:)
          user_entity = new(
            id: struct.id,
            name: struct.name,
            slug: struct.slug
          )
          user_entity.to_domain
        end

        # @rbs (workspace_entity: ::Domain::Entity::WorkSpace::WorkSpaceEntity) -> WorkSpaceEntity
        def self.build_from_domain_entity(workspace_entity:)
          new(
            id: ::UtilMethod.nil_or_empty?(workspace_entity.id&.value) ? SecureRandom.uuid : workspace_entity.id.value,
            name: workspace_entity.name,
            slug: workspace_entity.slug
          )
        end
      end
    end
  end
end
