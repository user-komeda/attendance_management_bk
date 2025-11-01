# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    class BaseResponse

      protected

      # @rbs (untyped value) -> Hash[Symbol, untyped]
      def self.build(value)
        raise NotImplementedError
      end

      # @rbs (Array[untyped] _value_list) -> Array[Hash[Symbol, untyped]]
      def self.build_from_array(_value_list)
        raise NotImplementedError
      end

      # @rbs () -> Hash[Symbol, untyped]
      def to_h
        raise NotImplementedError
      end
    end
  end
end