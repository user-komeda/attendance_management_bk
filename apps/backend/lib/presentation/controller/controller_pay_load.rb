# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    class ControllerPayLoad
      # @rbs @id: String
      # @rbs @status_code: Integer
      # @rbs @data: Array[untyped]
      attr_reader :id, :status_code, :data

      # @rbs (?id: String, ?status_code: Integer, ?data: Hash[Symbol, untyped] | Array[Hash[Symbol, untyped]]) -> void
      def initialize(id: '', status_code: 200, data: [])
        @id = id
        @status_code = status_code
        @data = data
      end
    end
  end
end
