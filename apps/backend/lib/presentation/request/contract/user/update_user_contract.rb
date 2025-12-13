# frozen_string_literal: true

# rbs_inline: enabled

require 'dry-validation'

module Presentation
  module Request
    module Contract
      module User
        class UpdateUserContract < Dry::Validation::Contract
          params do
            required(:id).value(::Presentation::Request::Types::UuidTypes::UUID)
            optional(:first_name).value(:string)
            optional(:last_name).value(:string)
            optional(:email).value(::Presentation::Request::Types::EmailTypes::Email)
          end
        end
      end
    end
  end
end
