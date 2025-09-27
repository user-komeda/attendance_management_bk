# frozen_string_literal: true

require 'dry-types'
module EmailTypes
  Email = Dry::Types['string'].constrained(format: /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i)
end
