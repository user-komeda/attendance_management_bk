# frozen_string_literal: true

# rbs_inline: enabled

require 'dry-validation'

module Presentation
  module Request
    module Contract
      module WorkSpace
        class UpdateWorkSpaceContract < Dry::Validation::Contract
          params do
            required(:id).filled(::Presentation::Request::Types::UuidTypes::UUID)
            optional(:name).filled(:string)
            optional(:slug).filled(:string)
          end
        end
      end
    end
  end
end
