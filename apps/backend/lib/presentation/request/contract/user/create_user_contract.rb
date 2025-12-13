# frozen_string_literal: true

# rbs_inline: enabled

require 'dry-validation'

module Presentation
  module Request
    module Contract
      module User
        class CreateUserContract < Dry::Validation::Contract
          params do
            required(:first_name).filled(:string)
            required(:last_name).filled(:string)
            required(:email).filled(::Presentation::Request::Types::EmailTypes::Email)
          end
        end
      end
    end
  end
end
