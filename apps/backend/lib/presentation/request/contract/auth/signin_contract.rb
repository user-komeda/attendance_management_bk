# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module Contract
      module Auth
        class SigninContract < Dry::Validation::Contract
          params do
            required(:email).filled(::Presentation::Request::Types::EmailTypes::Email)
            required(:password).filled(:string)
          end
        end
      end
    end
  end
end
