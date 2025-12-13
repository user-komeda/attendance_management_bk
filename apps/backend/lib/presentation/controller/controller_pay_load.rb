# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    class ControllerPayLoad
      attr_reader :id, :status_code, :data # : String # : Integer # : untyped

      # @rbs (?id: String, ?status_code: Integer, ?data: Hash[Symbol, untyped] | Array[Hash[Symbol, untyped]]) -> void
      def initialize(id: '', status_code: 200, data: [])
        @id = id
        @status_code = status_code
        @data = data
      end
    end
  end
end
