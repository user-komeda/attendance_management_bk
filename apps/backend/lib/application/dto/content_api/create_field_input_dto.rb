# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module ContentApi
      class CreateFieldInputDto < InputBaseDto
        # @rbs DEFAULT_SETTINGS: Hash[Symbol, untyped]
        DEFAULT_SETTINGS = { default: nil }.compact.freeze

        # rubocop:disable all
        attr_reader :field_id, :display_name, :field_type #: String
        attr_reader :required, :unique_value, :is_active #: bool
        attr_reader :order_index #: Integer
        attr_reader :settings #: Hash[Symbol, untyped]
        # rubocop:enable all

        # @rbs (params: Hash[Symbol, untyped]) -> void
        def initialize(params:)
          super()
          @field_id = params[:field_id]
          @display_name = params[:display_name]
          @field_type = params[:field_type]
          @required = params.fetch(:required, false)
          @unique_value = params.fetch(:unique_value, false)
          @order_index = params.fetch(:order_index, 0)
          @is_active = params.fetch(:is_active, true)
          @settings = params.fetch(:settings, DEFAULT_SETTINGS)
        end

        # @rbs (content_api_id: String) -> ::Domain::Entity::ContentApi::FieldEntity
        def convert_to_entity(content_api_id:)
          build_entity(content_api_id: content_api_id, field_params: build_field_params)
        end

        private

        def build_field_params
          {
            field_id: field_id,
            display_name: display_name,
            field_type: field_type,
            required: required,
            unique_value: unique_value,
            order_index: order_index,
            is_active: is_active,
            settings: settings
          }
        end

        # @rbs (content_api_id: String, field_params: Hash[Symbol, untyped]) -> ::Domain::Entity::ContentApi::FieldEntity
        def build_entity(content_api_id:, field_params:)
          return build_without_content_api_id(field_params: field_params) if content_api_id.empty?

          build_with_content_api_id(content_api_id: content_api_id, field_params: field_params)
        end

        # @rbs (field_params: Hash[Symbol, untyped]) -> ::Domain::Entity::ContentApi::FieldEntity
        def build_without_content_api_id(field_params:)
          ::Domain::Entity::ContentApi::FieldEntity.build_without_content_api_id(
            field_id: field_params[:field_id],
            display_name: field_params[:display_name],
            field_type: field_params[:field_type],
            required: field_params[:required],
            unique_value: field_params[:unique_value],
            order_index: field_params[:order_index],
            is_active: field_params[:is_active],
            settings: field_params[:settings]
          )
        end

        # @rbs (content_api_id: String, field_params: Hash[Symbol, untyped]) -> ::Domain::Entity::ContentApi::FieldEntity
        def build_with_content_api_id(content_api_id:, field_params:)
          ::Domain::Entity::ContentApi::FieldEntity.build(
            content_api_id: content_api_id,
            field_id: field_params[:field_id],
            display_name: field_params[:display_name],
            field_type: field_params[:field_type],
            required: field_params[:required],
            unique_value: field_params[:unique_value],
            order_index: field_params[:order_index],
            is_active: field_params[:is_active],
            settings: field_params[:settings]
          )
        end
      end
    end
  end
end
