# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Entity
    module ContentApi
      class FieldEntity < DomainEntity
        ID = ::Domain::ValueObject::IdentityId.freeze

        attr_reader :id, :content_api_id, :field_id, :display_name, :field_type,
                    :required, :unique_value, :order_index, :is_active, :settings

        # : ::Domain::ValueObject::IdentityId?
        # : ::Domain::ValueObject::IdentityId
        # : String
        # : String
        # : String
        # : bool
        # : bool
        # : Integer
        # : bool
        # : Hash[Symbol, untyped]

        # @rbs (params: Hash[Symbol, untyped]) -> void
        def initialize(params:)
          super()
          @id = params[:id]
          @content_api_id = params.fetch(:content_api_id)
          @field_id = params.fetch(:field_id)
          @display_name = params.fetch(:display_name)
          @field_type = params.fetch(:field_type)
          @required = params.fetch(:required)
          @unique_value = params.fetch(:unique_value)
          @order_index = params.fetch(:order_index)
          @is_active = params.fetch(:is_active)
          @settings = params.fetch(:settings)
        end

        # @rbs (params: Hash[Symbol, untyped]) -> FieldEntity
        def self.build(params)
          new(params: {
                content_api_id: ID.build(params.fetch(:content_api_id)),
                field_id: params.fetch(:field_id),
                display_name: params.fetch(:display_name),
                field_type: params.fetch(:field_type),
                required: params.fetch(:required),
                unique_value: params.fetch(:unique_value),
                order_index: params.fetch(:order_index),
                is_active: params.fetch(:is_active),
                settings: params.fetch(:settings)
              })
        end

        # @rbs (params: Hash[Symbol, untyped]) -> FieldEntity
        def self.build_without_content_api_id(params)
          new(params: {
                content_api_id: ID.build(SecureRandom.uuid),
                field_id: params.fetch(:field_id),
                display_name: params.fetch(:display_name),
                field_type: params.fetch(:field_type),
                required: params.fetch(:required),
                unique_value: params.fetch(:unique_value),
                order_index: params.fetch(:order_index),
                is_active: params.fetch(:is_active),
                settings: params.fetch(:settings)
              })
        end

        # @rbs (attrs: Hash[Symbol, untyped]) -> FieldEntity
        def self.build_with_id(attrs)
          new(params: {
                id: ID.build(attrs.fetch(:id)),
                content_api_id: ID.build(attrs.fetch(:content_api_id)),
                field_id: attrs.fetch(:field_id),
                display_name: attrs.fetch(:display_name),
                field_type: attrs.fetch(:field_type),
                required: attrs.fetch(:required),
                unique_value: attrs.fetch(:unique_value),
                order_index: attrs.fetch(:order_index),
                is_active: attrs.fetch(:is_active),
                settings: attrs.fetch(:settings)
              })
        end
      end
    end
  end
end
