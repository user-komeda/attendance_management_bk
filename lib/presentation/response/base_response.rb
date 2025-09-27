# frozen_string_literal: true

module Presentation
  module Response
    class BaseResponse
      def self.buid(value)
        raise NotImplementedError
      end

      def self.build_from_array(_value_list)
        NotImplementedError
      end

      def to_h
        raise NotImplementedError
      end
    end
  end
end
