# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module ContentApi
      class CreateFieldInputDto < InputBaseDto
        attr_reader :field_id, :display_name, :field_type,
                    :required, :unique_value, :is_active,
                    :order_index, :settings

        # : String
        # : bool
        # : Integer
        # : Hash[Symbol, untyped]

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
          default_settings = {} # : Hash[Symbol, untyped]
          @settings = params.fetch(:settings, default_settings)
        end

        # @rbs (content_api_id: String) -> ::Domain::Entity::ContentApi::FieldEntity
        def convert_to_entity(content_api_id:)
          field_params = build_field_params
          if content_api_id.empty?
            return ::Domain::Entity::ContentApi::FieldEntity.build_without_content_api_id(**field_params)
          end

          ::Domain::Entity::ContentApi::FieldEntity.build(content_api_id: content_api_id, **field_params)
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
      end
    end
  end
end
