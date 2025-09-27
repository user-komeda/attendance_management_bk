# frozen_string_literal: true

module Application
  module Dto
    class BaseDto
      def self.build(value)
        raise NotImplementedError
      end

      def self.build_from_array(value_list)
        raise NotImplementedError
      end
    end
  end
end
