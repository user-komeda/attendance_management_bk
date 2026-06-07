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

        # @rbs (message: String) -> void
        attr_reader :value # :String

        # @rbs (message: String) -> void

        # @rbs (String value) -> void
        def initialize(value)
          super()
          @value = value
          @value.freeze
        end

        # @rbs (String value) -> bool
        def match?(password)
          ::PasswordEncryptor.matches?(password, value)
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

        # @rbs (String message) -> void
        def self.raise_password_error(message)
          raise ::Domain::Exception::InvalidPasswordError.new(
            message: message,
            field_errors: [{ key: 'password', message: message }]
          )
        end

        # @rbs (String value) -> void
        def self.validate!(value)
          raise_password_error('パスワードは必須です') if ::UtilMethod.nil_or_empty?(value)
          raise_password_error('8文字以上入力してください') if value.length < MIN_LENGTH
          raise_password_error('英大文字を1文字以上含めてください') unless value.match?(REGEX_UPPER)
          raise_password_error('英小文字を1文字以上含めてください') unless value.match?(REGEX_LOWER)
          raise_password_error('数字を含めてください') unless value.match?(REGEX_DIGIT)
        end
      end
    end
  end
end
