# frozen_string_literal: true

module Domain
  module ValueObject
    class IdentityId < BaseValueObject
      attr_reader :value

      private_class_method :new

      def initialize(args)
        super()
        @value = args
      end

      def self.build(args)
        validate!(args)
        new(args).freeze
      end

      class << self
        def self.validate!(args)
          raise ArgumentError, 'IdentityId cannot be nil' if args.nil?
        end

        def values
          [value]
        end
      end
    end
  end
end
