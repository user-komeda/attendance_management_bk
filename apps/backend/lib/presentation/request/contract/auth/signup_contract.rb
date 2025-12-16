# frozen_string_literal: true

# rbs_inline: enabled

require 'dry-validation'

module Presentation
  module Request
    module Contract
      module Auth
        class SignupContract < Dry::Validation::Contract
          params do
            required(:email).filled(::Presentation::Request::Types::EmailTypes::Email)
            required(:password).filled(:string)
            required(:first_name).filled(:string)
            required(:last_name).filled(:string)
          end
        end
      end
    end
  end
end
