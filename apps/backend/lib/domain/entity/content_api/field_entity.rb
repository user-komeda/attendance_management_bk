# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Entity
    module ContentApi
      class FieldEntity < DomainEntity
        ID = ::Domain::ValueObject::IdentityId.freeze

        # rubocop:disable all
        attr_reader :id #: ::Domain::ValueObject::IdentityId?
        attr_reader :content_api_id #: ::Domain::ValueObject::IdentityId
        attr_reader :field_id #: String
        attr_reader :display_name #: String
        attr_reader :field_type #: String
        attr_reader :required #: bool
        attr_reader :unique_value #: bool
        attr_reader :order_index #: Integer
        attr_reader :is_active #: bool
        attr_reader :settings #: Hash[Symbol, untyped]
        # rubocop:enable all

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

        # rubocop:disable all
        # @rbs (content_api_id: String, field_id: String, display_name: String, field_type: String, required: bool, unique_value: bool, order_index: Integer, is_active: bool, settings: Hash[Symbol, untyped]) -> FieldEntity
        # rubocop:enable all
        def self.build(**params)
          new(params: build_params(params: params, content_api_id: ID.build(params.fetch(:content_api_id))))
        end

        # rubocop:disable all
        # @rbs (field_id: String, display_name: String, field_type: String, required: bool, unique_value: bool, order_index: Integer, is_active: bool, settings: Hash[Symbol, untyped]) -> FieldEntity
        # rubocop:enable all
        def self.build_without_content_api_id(**params)
          new(params: build_params(params: params, content_api_id: ID.build(SecureRandom.uuid)))
        end

        # rubocop:disable all
        # @rbs (id: String, content_api_id: String, field_id: String, display_name: String, field_type: String, required: bool, unique_value: bool, order_index: Integer, is_active: bool, settings: Hash[Symbol, untyped]) -> FieldEntity
        # rubocop:enable all
        def self.build_with_id(**params)
          base_params = build_params(params: params, content_api_id: ID.build(params.fetch(:content_api_id)))
          new(params: base_params.merge(id: ID.build(params.fetch(:id))))
        end

        class << self
          private

          # rubocop:disable all
          # @rbs (params: Hash[Symbol, untyped], content_api_id: ::Domain::ValueObject::IdentityId) -> Hash[Symbol, untyped]
          # rubocop:enable all
          def build_params(params:, content_api_id:)
            {
              content_api_id: content_api_id,
              field_id: params.fetch(:field_id),
              display_name: params.fetch(:display_name),
              field_type: params.fetch(:field_type),
              required: params.fetch(:required),
              unique_value: params.fetch(:unique_value),
              order_index: params.fetch(:order_index),
              is_active: params.fetch(:is_active),
              settings: params.fetch(:settings)
            }
          end
        end
      end
    end
  end
end
