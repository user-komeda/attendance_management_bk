# frozen_string_literal: true

module Presentation
  module Controller
    class ControllerPayLoad
      attr_reader :id, :status_code, :data

      def initialize(id: '', status_code: 200, data: [])
        @id = id
        @status_code = status_code
        @data = data
      end
    end
  end
end
