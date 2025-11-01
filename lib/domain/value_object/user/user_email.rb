# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module ValueObject
    module User
      class UserEmail < BaseValueObject
        # @rbs @value: String
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

        # 繧､繝ｳ繧ｹ繧ｿ繝ｳ繧ｹ繝｡繧ｽ繝・ラ縺ｨ縺励※螳夂ｾｩ
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