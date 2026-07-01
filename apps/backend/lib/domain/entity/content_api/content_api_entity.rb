# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Entity
    module ContentApi
      class ContentApiEntity < DomainEntity
        ID = ::Domain::ValueObject::IdentityId.freeze

        # rubocop:disable all
        attr_reader :id #: ::Domain::ValueObject::IdentityId
        attr_reader :work_space_id #: ::Domain::ValueObject::IdentityId
        attr_reader :name #: String
        attr_reader :endpoint #: String
        attr_reader :api_type #: String
        attr_reader :fields #: Array[::Domain::Entity::ContentApi::FieldEntity]
        # rubocop:enable all

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

        # rubocop:disable all
        # @rbs (work_space_id: String, name: String, endpoint: String, api_type: String, fields: Array[::Domain::Entity::ContentApi::FieldEntity]) -> ContentApiEntity
        # rubocop:enable all
        def self.build(**params)
          new(params: build_params(params: params))
        end

        # rubocop:disable all
        # @rbs (id: String, work_space_id: String, name: String, endpoint: String, api_type: String, fields: Array[::Domain::Entity::ContentApi::FieldEntity]) -> ContentApiEntity
        # rubocop:enable all
        def self.build_with_id(**params)
          new(params: build_params(params: params).merge(id: ID.build(params.fetch(:id))))
        end

        class << self
          private

          # @rbs (params: Hash[Symbol, untyped]) -> Hash[Symbol, untyped]
          def build_params(params:)
            {
              work_space_id: ID.build(params.fetch(:work_space_id)),
              name: params.fetch(:name),
              endpoint: params.fetch(:endpoint),
              api_type: params.fetch(:api_type),
              fields: params.fetch(:fields, [])
            }
          end
        end
      end
    end
  end
end
