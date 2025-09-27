# frozen_string_literal: true

require 'dry-types'

module Presentation
  module Request
    module Contract
      module UUIDTypes
        UUID = Dry::Types['string'].constrained(
          format: /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i
        )
      end
    end
  end
end
