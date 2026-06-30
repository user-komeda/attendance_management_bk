# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Entity
    module ContentApi
      class ContentApiEntity < DomainEntity
        ID = ::Domain::ValueObject::IdentityId.freeze

        attr_reader :id, :work_space_id, :name, :endpoint, :api_type, :fields

        # : ::Domain::ValueObject::IdentityId
        # : ::Domain::ValueObject::IdentityId
        # : String
        # : String
        # : String
        # : Array[::Domain::Entity::ContentApi::FieldEntity]

        # @rbs (params: Hash[Symbol, untyped]) -> void
        def initialize(params:)
          super()
          @id = params[:id]
          @work_space_id = params[:work_space_id]
          @name = params[:name]
          @endpoint = params[:endpoint]
          @api_type = params[:api_type]
          @fields = params.fetch(:fields, [])
        end

        # @rbs (params: Hash[Symbol, untyped]) -> ContentApiEntity
        def self.build(work_space_id:, name:, endpoint:, api_type:, fields: [])
          new(params: {
                work_space_id: ID.build(work_space_id),
                name: name,
                endpoint: endpoint,
                api_type: api_type,
                fields: fields
              })
        end

        # @rbs (params: Hash[Symbol, untyped]) -> ContentApiEntity
        def self.build_with_id(attrs)
          new(params: {
                id: ID.build(attrs.fetch(:id)),
                work_space_id: ID.build(attrs.fetch(:work_space_id)),
                name: attrs.fetch(:name),
                endpoint: attrs.fetch(:endpoint),
                api_type: attrs.fetch(:api_type),
                fields: attrs.fetch(:fields, [])
              })
        end
      end
    end
  end
end
