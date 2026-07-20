# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module ContentApi
      class FieldBaseRequest < BaseRequest
        # rubocop:disable all
        attr_reader :field_id, :display_name, :field_type #: String
        attr_reader :required, :unique_value, :is_active #: bool
        attr_reader :order_index #: Integer
        attr_reader :settings #: Hash[Symbol, untyped]
        # rubocop:enable all

        CREATE_INPUT_DTO = ::Application::Dto::ContentApi::CreateFieldInputDto.freeze
        CREATE_CONTRACT = ::Presentation::Request::Contract::ContentApi::CreateFieldContract
      end
    end
  end
end
