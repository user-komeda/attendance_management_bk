# frozen_string_literal: true

# rbs_inline: enabled

require 'dry-validation'

module Presentation
  module Request
    module Contract
      module WorkSpace
        class CreateWorkSpaceContract < Dry::Validation::Contract
          params do
            required(:name).filled(:string)
            required(:slug).filled(:string)
          end
        end
      end
    end
  end
end
