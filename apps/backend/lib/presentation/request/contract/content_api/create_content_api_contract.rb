# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module Contract
      module ContentApi
        class CreateContentApiContract < Dry::Validation::Contract
          params do
            required(:name).filled(:string)
            required(:endpoint).filled(:string)
            required(:api_type).filled(:string)
          end

          rule(:endpoint) do
            unless /\A[a-z0-9-]{3,32}\z/.match?(value)
              key.failure('must be 3-32 chars and contain only lowercase letters, numbers, or hyphens')
            end
          end

          rule(:api_type) do
            key.failure('must be list or object') unless %w[list object].include?(value)
          end
        end
      end
    end
  end
end
