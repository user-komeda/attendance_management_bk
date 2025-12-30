# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Entity
    module Auth
      class AuthUserEntity
        # rubocop:disable all
        attr_reader :id #: Domain::ValueObject::IdentityId?
        attr_reader :user_id #: String?
        attr_reader :email #: Domain::ValueObject::User::UserEmail
        attr_reader :password_digest #: Domain::ValueObject::AuthUser::PasswordDigest
        attr_reader :provider #: String?
        attr_reader :is_active #: bool?
        attr_reader :last_login_at #: Time?
        # rubocop:enable all

        PASSWORD_DIGEST = ::Domain::ValueObject::AuthUser::PasswordDigest.freeze
        UE = ::Domain::ValueObject::User::UserEmail.freeze
        ID = ::Domain::ValueObject::IdentityId.freeze

        private_class_method :new

        # rubocop:disable Layout/LineLength
        # @rbs ({id: Domain::ValueObject::IdentityId?, user_id: String?, email: Domain::ValueObject::User::UserEmail, password_digest: Domain::ValueObject::AuthUser::PasswordDigest, provider: String?, is_active: bool?, last_login_at: Time?}) -> void
        # rubocop:enable Layout/LineLength
        def initialize(attrs)
          @id = attrs.fetch(:id)
          @user_id = attrs.fetch(:user_id)
          @email = attrs.fetch(:email)
          @password_digest = attrs.fetch(:password_digest)
          @provider = attrs.fetch(:provider)
          @is_active = attrs.fetch(:is_active)
          @last_login_at = attrs.fetch(:last_login_at)
        end

        # @rbs (String password) -> bool
        def password_match?(password)
          ::PasswordEncryptor.matches?(password, @password_digest.value)
        end

        # @rbs () -> bool
        def active?
          !!@is_active
        end

        # rubocop:disable Layout/LineLength
        # @rbs ({?user_id: String, email: String, password: String, ?provider: String, ?is_active: bool, ?last_login_at: Time?}) -> AuthUserEntity
        # rubocop:enable Layout/LineLength
        def self.build(attrs)
          new(
            id: nil,
            user_id: attrs.fetch(:user_id, nil),
            email: UE.build(attrs.fetch(:email)),
            password_digest: PASSWORD_DIGEST.build(attrs.fetch(:password)),
            provider: attrs.fetch(:provider, nil),
            is_active: attrs.fetch(:is_active, nil),
            last_login_at: attrs.fetch(:last_login_at, nil)
          )
        end

        # rubocop:disable Layout/LineLength
        # @rbs ({id: String, user_id: String, email: String, password: String, provider: String, is_active: bool, last_login_at: Time?}) -> AuthUserEntity
        # rubocop:enable Layout/LineLength
        def self.build_with_id(attrs)
          new(
            id: ID.build(attrs.fetch(:id)),
            user_id: attrs.fetch(:user_id),
            email: UE.build(attrs.fetch(:email)),
            password_digest: PASSWORD_DIGEST.build(attrs.fetch(:password)),
            provider: attrs.fetch(:provider),
            is_active: attrs.fetch(:is_active),
            last_login_at: attrs.fetch(:last_login_at)
          )
        end
      end
    end
  end
end
