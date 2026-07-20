# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module Contract
      module ContentApi
        class CreateFieldContract < Dry::Validation::Contract
          FIELD_TYPES = %w[
            text
            textarea
            rich_text
            number
            boolean
            date
            datetime
            image
            file
            select
            multi_select
            relation
            relation_list
            custom_field
            repeat_field
            json
          ].freeze

          params do
            required(:field_id).filled(:string)
            required(:display_name).filled(:string)
            required(:field_type).filled(:string)

            optional(:required).filled(:bool)
            optional(:unique_value).filled(:bool)
            optional(:order_index).filled(:integer)
            optional(:is_active).filled(:bool)
            optional(:settings).filled(:hash)
          end

          rule(:field_id) do
            unless /\A[a-zA-Z][a-zA-Z0-9_]*\z/.match?(value)
              key.failure('must start with a letter and contain only letters, numbers, or underscores')
            end
          end

          rule(:field_type) do
            key.failure('is not supported') unless FIELD_TYPES.include?(value)
          end
        end
      end
    end
  end
end
