# frozen_string_literal: true

module Application
  module Dto
    class InputBaseDto
      def convert_to_entity
        raise NotImplementedError
      end
    end
  end
end
