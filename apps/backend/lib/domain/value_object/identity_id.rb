# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module ValueObject
    class IdentityId < BaseValueObject
      # @rbs @value: String
      attr_reader :value

      private_class_method :new

      # @rbs (String args) -> void
      def initialize(args)
        super()
        @value = args
      end

      # @rbs (String args) -> IdentityId
      def self.build(args)
        validate!(args)
        new(args).freeze
      end

      # @rbs () -> Array[String]
      def values
        [value]
      end

      # @rbs (String args) -> void
      def self.validate!(args)
        raise ArgumentError, 'IdentityId cannot be nil' if args.nil?
      end
    end
  end
end
