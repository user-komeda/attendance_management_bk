
# frozen_string_literal: true
# rbs_inline: enabled


module Application
  module Dto
    class InputBaseDto
      # @rbs () -> ::Domain::Entity::DomainEntity
      def convert_to_entity
        raise NotImplementedError
      end
    end
  end
end