# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Entity
    module Auth
      class AuthUserEntity # : Domain::ValueObject::IdentityId # : String # : Domain::ValueObject::User::UserEmail # : ::Domain::ValueObject::AuthUser::PasswordDigest # : String # : bool
        attr_reader :id, :user_id, :email, :password_digest, :provider, :is_active, :last_login_at # : Time|nil

        PASSWORD_DIGEST = ::Domain::ValueObject::AuthUser::PasswordDigest.freeze
        UE = ::Domain::ValueObject::User::UserEmail.freeze
        ID = ::Domain::ValueObject::IdentityId.freeze

        private_class_method :new

        # rubocop:disable Layout/LineLength
        # @rbs ({id: Domain::ValueObject::IdentityId?, user_id: String?, email: Domain::ValueObject::User::UserEmail, password_digest: Domain::ValueObject::AuthUser::PasswordDigest, provider: String?, is_active: bool?, last_login_at: Time?}) -> AuthUserEntity
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

        # rubocop:disable Layout/LineLength
        # @rbs ({?id: String, ?user_id: String, email: String, password: String, ?provider: String, ?is_active: bool, ?last_login_at: Time?}) -> AuthUserEntity
        # rubocop:enable Layout/LineLength
        def self.build(attrs)
          new(
            id: ID.build(attrs.fetch(:id, nil)),
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
