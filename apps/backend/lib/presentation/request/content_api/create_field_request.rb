# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module ContentApi
      class CreateFieldRequest < FieldBaseRequest
        # @rbs DEFAULT_SETTINGS: Hash[Symbol, untyped]
        DEFAULT_SETTINGS = { default: nil }.compact.freeze
        # @rbs (params: Hash[Symbol, untyped]) -> void
        def initialize(params:)
          super()
          apply_attributes(params: normalize_params(params: params))
        end

        # @rbs () -> ::Application::Dto::ContentApi::CreateFieldInputDto
        def convert_to_dto
          CREATE_INPUT_DTO.new(params: dto_params)
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
            validate_or_raise!(contract: FieldBaseRequest::CREATE_CONTRACT, params: params)
          end
        end

        private

        # @rbs (params: Hash[Symbol, untyped]) -> void
        def apply_attributes(params:)
          @params = params
        end

        # @rbs (params: Hash[Symbol, untyped]) -> Hash[Symbol, untyped]
        def normalize_params(params:)
          {
            field_id: params[:field_id],
            display_name: params[:display_name],
            field_type: params[:field_type],
            required: params.fetch(:required, false),
            unique_value: params.fetch(:unique_value, false),
            order_index: params.fetch(:order_index, 0),
            is_active: params.fetch(:is_active, true),
            settings: params.fetch(:settings, DEFAULT_SETTINGS)
          }
        end

        # @rbs () -> Hash[Symbol, untyped]
        def dto_params
          @params
        end
      end
    end
  end
end
