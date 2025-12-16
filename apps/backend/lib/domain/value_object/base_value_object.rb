# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module ValueObject
    class BaseValueObject
      # @rbs (*untyped args) -> BaseValueObject
      def self.build(*args)
        raise NotImplementedError, 'Subclasses must implement .build'
      end

      # @rbs (untyped other) -> bool
      def ==(other)
        self.class == other.class && values == other.values
      end

      # @rbs (untyped other) -> bool
      def eql?(other)
        self == other
      end

      # @rbs () -> Integer
      def hash
        values.hash
      end

      # @rbs () -> Array[untyped]
      def values
        raise NotImplementedError, 'Subclasses must implement #values'
      end

      class << self
        private

        # @rbs (untyped value) -> void
        def validate!(value)
          raise NotImplementedError, 'Subclasses must implement .validate!'
        end
      end
    end
  end
end
