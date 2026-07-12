# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module Contract
      module WorkSpace
        class UpdateWorkSpaceContract < Dry::Validation::Contract
          params do
            required(:id).filled(:string)
            optional(:name).filled(:string)
            optional(:slug).filled(:string)
          end
        end
      end
    end
  end
end
