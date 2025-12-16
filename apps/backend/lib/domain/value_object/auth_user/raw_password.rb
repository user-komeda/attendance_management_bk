# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module ValueObject
    module AuthUser
      class RawPassword
        private_class_method :new
        # @rbs!
        #   attr_reader value: String
        attr_reader :value

        # @rbs (String value) -> void
        def initialize(value)
          @value = value
          @value.freeze
        end

        # @rbs (String value) -> RawPassword
        def self.build(value)
          validate!(value)
          new(value)
        end

        # @rbs () -> Array[String]
        def values
          [value]
        end

        class << self
          private

          # @rbs (String value) -> void
          def validate!(value)
            raise ArgumentError, 'RawPassword cannot be nil' if ::UtilMethod.nil_or_empty?(value)
          end
        end
      end
    end
  end
end
