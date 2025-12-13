# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module ValueObject
    module AuthUser
      class PasswordDigest < BaseValueObject
        MIN_LENGTH = 8
        REGEX_UPPER = /[A-Z]/
        REGEX_LOWER = /[a-z]/
        REGEX_DIGIT = /[0-9]/
        private_class_method :new

        attr_reader :value # :String

        # @rbs (String value) -> void
        def initialize(value)
          super()
          @value = value
          @value.freeze
        end

        # @rbs (String value) -> void
        def self.build(value)
          # すでにハッシュ済みなら validate! をスキップ
          return new(value) if hashed_password?(value)

          validate!(value)
          new(::PasswordEncryptor.digest(value))
        end

        # @rbs (String value) -> bool
        def self.hashed_password?(value)
          # bcrypt を想定：60文字、先頭が $2 (アルゴリズム識別子)
          value.is_a?(String) && value.length >= 60 && value.start_with?('$2')
        end

        # @rbs () -> Array[String]
        def values
          [value]
        end

        # @rbs (String value) -> void
        def self.validate!(value)
          if ::UtilMethod.nil_or_empty?(value)
            raise ::Domain::Exception::InvalidPasswordError.new(message: 'パスワードは必須です')
          end
          raise ::Domain::Exception::InvalidPasswordError.new(message: '8文字以上入力してください') if value.length < MIN_LENGTH
          unless value.match?(REGEX_UPPER)
            raise ::Domain::Exception::InvalidPasswordError.new(message: '英大文字を1文字以上含めてください')
          end
          unless value.match?(REGEX_LOWER)
            raise ::Domain::Exception::InvalidPasswordError.new(message: '英小文字を1文字以上含めてください')
          end
          raise ::Domain::Exception::InvalidPasswordError.new(message: '数字を含めてください') unless value.match?(REGEX_DIGIT)
        end
      end
    end
  end
end
