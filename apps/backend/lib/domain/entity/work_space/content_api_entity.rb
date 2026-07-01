# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Entity
    module WorkSpace
      class ContentApiEntity < DomainEntity
        ID = ::Domain::ValueObject::IdentityId.freeze

        # rubocop:disable all
        attr_reader :id #: ::Domain::ValueObject::IdentityId
        attr_reader :work_space_id #: ::Domain::ValueObject::IdentityId
        attr_reader :name #: String
        attr_reader :endpoint #: String
        attr_reader :api_type #: String
        # rubocop:enable all

        # rubocop:disable all
        # @rbs (work_space_id: ::Domain::ValueObject::IdentityId, name: String, endpoint: String, api_type: String, id: ::Domain::ValueObject::IdentityId?) -> void
        # rubocop:enable all
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
            id: nil,
            work_space_id: ID.build(work_space_id),
            name: name,
            endpoint: endpoint,
            api_type: api_type
          )
        end

        # @rbs (id: String, work_space_id: String, name: String, endpoint: String, api_type: String) -> ContentApiEntity
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
