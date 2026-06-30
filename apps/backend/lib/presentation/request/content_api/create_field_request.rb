# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module ContentApi
      class CreateFieldRequest < FieldBaseRequest
        # @rbs (params: Hash[Symbol, untyped]) -> void
        # rubocop:enable all
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

        # @rbs () -> ::Application::Dto::ContentApi::CreateFieldInputDto
        def convert_to_dto
          CREATE_INPUT_DTO.new(
            params: {
              field_id: @field_id,
              display_name: @display_name,
              field_type: @field_type,
              required: @required,
              unique_value: @unique_value,
              order_index: @order_index,
              is_active: @is_active,
              settings: @settings
            }
          )
        end

        # @rbs (params: Hash[Symbol, untyped]) -> CreateFieldRequest
        def self.build(params:)
          validate(params: params)
          CreateFieldRequest.new(params: params)
        end

        class << self
          private

          # @rbs (params: Hash[Symbol, untyped]) -> void
          def validate(params:)
            result = FieldBaseRequest::CREATE_CONTRACT.new.call(params)
            return unless result.failure?

            raise ::Presentation::Exception::BadRequestException.new(message: result.errors.to_h.to_json)
          end
        end
      end
    end
  end
end
