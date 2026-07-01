# frozen_string_literal: true

# rbs_inline: enabled

require_relative '../../mapper/content_api_mapper'

module Infrastructure
  module Entity
    module WorkSpace
      # WorkSpace に紐づく ContentApi の永続化データを Domain Entity に変換する ROM Struct です。
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

        # @rbs () -> ::Domain::Entity::WorkSpace::ContentApiEntity
        def to_domain
          ::Infrastructure::Mapper::ContentApiMapper.work_space_content_api_domain_from_struct(struct: self)
        end

        # @rbs (struct: untyped) -> ::Domain::Entity::WorkSpace::ContentApiEntity
        def self.struct_to_domain(struct:)
          ::Infrastructure::Mapper::ContentApiMapper.work_space_content_api_domain_from_struct(struct: struct)
        end

        # @rbs (content_api_entity: ::Domain::Entity::WorkSpace::ContentApiEntity) -> ContentApiEntity
        def self.build_from_domain_entity(content_api_entity:)
          new(
            ::Infrastructure::Mapper::ContentApiMapper.work_space_content_api_infra_attributes_from_domain(
              domain: content_api_entity
            )
          )
        end
      end
    end
  end
end
