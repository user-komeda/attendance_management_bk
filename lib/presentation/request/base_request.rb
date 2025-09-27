# frozen_string_literal: true

module Presentation
  module Request
    class BaseRequest
      def convert_to_dto
        raise NotImplementedError
      end

      def self.build(params)
        raise NotImplementedError
      end

      def self.validate(params)
        raise NotImplementedError
      end
    end
  end
end
