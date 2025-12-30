# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    class ControllerPayLoad
      # rubocop:disable all
      attr_reader :id #: String
      attr_reader :status_code #: Integer
      attr_reader :data #: untyped
      # rubocop:enable all

      # @rbs (?id: String, ?status_code: Integer, ?data: Hash[Symbol, untyped] | Array[Hash[Symbol, untyped]]) -> void
      def initialize(id: '', status_code: 200, data: [])
        @id = id
        @status_code = status_code
        @data = data
      end
    end
  end
end
