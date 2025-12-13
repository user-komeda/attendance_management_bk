# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module ValueObject
    module User
      class UserEmail < BaseValueObject
        # @rbs!
        #   attr_reader value: String
        attr_reader :value

        private_class_method :new

        # @rbs (String? value) -> void
        def initialize(value)
          super()
          @value = value
        end

        # @rbs (String email) -> UserEmail
        def self.build(email)
          validate!(email)
          new(email).freeze
        end

        # @rbs () -> Array[String]
        def values
          [value]
        end

        # @rbs (String args) -> void
        def self.validate!(args)
          raise ArgumentError, 'Email cannot be nil' if args.nil?
        end
      end
    end
  end
end
