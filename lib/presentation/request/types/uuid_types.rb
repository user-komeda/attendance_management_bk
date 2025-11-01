# frozen_string_literal: true

# rbs_inline: enabled

require 'dry-types'

module Presentation
  module Request
    module Contract
      module UUIDTypes
        # @rbs UUID: untyped
        UUID = Dry::Types['string'].constrained(
          format: /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i
        )
      end
    end
  end
end