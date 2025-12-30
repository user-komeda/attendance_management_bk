# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module ValueObject
    class IdentityId < BaseValueObject
      # rubocop:disable all
      attr_reader :value #: String
      # rubocop:enable all

      private_class_method :new

      # @rbs (String args) -> void
      def initialize(value)
        super()
        @value = value
      end

      # @rbs (String value) -> IdentityId
      def self.build(value)
        validate!(value)
        new(value).freeze
      end

      # @rbs () -> Array[String]
      def values
        [value]
      end

      class << self
        private

        # @rbs (String value) -> void
        def validate!(value)
          raise ArgumentError, 'IdentityId cannot be nil' if ::UtilMethod.nil_or_empty?(value)
        end
      end
    end
  end
end
