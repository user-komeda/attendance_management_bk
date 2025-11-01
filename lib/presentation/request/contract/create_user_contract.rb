# frozen_string_literal: true

# rbs_inline: enabled

require 'dry-validation'
require_relative '../types/email_types'

module Presentation
  module Request
    module Contract
      class CreateUserContract < Dry::Validation::Contract
        params do
          required(:first_name).filled(:string)
          required(:last_name).filled(:string)
          required(:email).filled(EmailTypes::Email)
        end
      end
    end
  end
end