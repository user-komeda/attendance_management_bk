# frozen_string_literal: true

# rbs_inline: enabled

require 'dry-types'
module Presentation
  module Request
    module Types
      module EmailTypes
        # @rbs Email: untyped
        Email = Dry::Types['string'].constrained(format: /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i)
      end
    end
  end
end
