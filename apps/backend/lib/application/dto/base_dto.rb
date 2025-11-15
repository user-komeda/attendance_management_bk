# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    class BaseDto
      # @rbs (::Domain::Entity::DomainEntity value) -> BaseDto
      def self.build(value)
        raise NotImplementedError
      end

      # @rbs (Array[::Domain::Entity::DomainEntity] value_list) -> Array[BaseDto]
      def self.build_from_array(value_list)
        raise NotImplementedError
      end
    end
  end
end
