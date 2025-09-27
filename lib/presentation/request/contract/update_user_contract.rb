# frozen_string_literal: true

require 'dry-validation'
require_relative '../types/email_types'
require_relative '../types/uuid_types'
module Presentation
  module Request
    module Contract
      class UpdateUserContract < Dry::Validation::Contract
        params do
          required(:id).value(UUIDTypes::UUID)
          optional(:first_name).value(:string)
          optional(:last_name).value(:string)
          optional(:email).value(EmailTypes::Email)
        end
      end
    end
  end
end
