# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Entity
    module WorkSpace
      class ContentApiEntity < DomainEntity
        ID = ::Domain::ValueObject::IdentityId.freeze

        attr_reader :id, :work_space_id, :name, :endpoint, :api_type

        # : ::Domain::ValueObject::IdentityId
        # : ::Domain::ValueObject::IdentityId
        # : String
        # : String
        # : String

        # @rbs (
        #   work_space_id: ::Domain::ValueObject::IdentityId,
        #   name: String,
        #   endpoint: String,
        #   api_type: String,
        #   ?id: ::Domain::ValueObject::IdentityId?
        # ) -> void
        def initialize(work_space_id:, name:, endpoint:, api_type:, id: nil)
          super()
          @id = id
          @work_space_id = work_space_id
          @name = name
          @endpoint = endpoint
          @api_type = api_type
        end

        # @rbs (work_space_id: String, name: String, endpoint: String, api_type: String) -> ContentApiEntity
        def self.build(work_space_id:, name:, endpoint:, api_type:)
          new(
            work_space_id: ID.build(work_space_id),
            name: name,
            endpoint: endpoint,
            api_type: api_type
          )
        end

        # @rbs (
        #   id: String,
        #   work_space_id: String,
        #   name: String,
        #   endpoint: String,
        #   api_type: String
        # ) -> ContentApiEntity
        def self.build_with_id(id:, work_space_id:, name:, endpoint:, api_type:)
          new(
            id: ID.build(id),
            work_space_id: ID.build(work_space_id),
            name: name,
            endpoint: endpoint,
            api_type: api_type
          )
        end
      end
    end
  end
end
