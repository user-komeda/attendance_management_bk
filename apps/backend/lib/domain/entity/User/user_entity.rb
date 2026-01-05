# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Entity
    module User
      class UserEntity
        ID = ::Domain::ValueObject::IdentityId.freeze
        UN = ::Domain::ValueObject::User::UserName.freeze
        UE = ::Domain::ValueObject::User::UserEmail.freeze

        # rubocop:disable all
        attr_reader :id #: ::Domain::ValueObject::IdentityId
        attr_reader :user_name #: ::Domain::ValueObject::User::UserName
        attr_reader :email #: ::Domain::ValueObject::User::UserEmail
        attr_reader :session_version #: Integer?
        # rubocop:enable all

        # rubocop:disable Layout/LineLength
        # @rbs (user_name: ::Domain::ValueObject::User::UserName, email: ::Domain::ValueObject::User::UserEmail, session_version: Integer?, ?id: ::Domain::ValueObject::IdentityId?) -> void
        # rubocop:enable Layout/LineLength
        def initialize(user_name:, email:, session_version: nil, id: nil)
          @id = id
          @user_name = user_name
          @email = email
          @session_version = session_version
        end

        # @rbs (first_name: String?, last_name: String?, email: String?) -> void
        def change(first_name:, last_name:, email:)
          return if no_changes?(first_name: first_name, last_name: last_name, email: email)

          update_user_name(first_name: first_name, last_name: last_name)
          update_email(email: email)
        end

        def self.build(first_name:, last_name:, email:, session_version: nil)
          new(
            user_name: UN.build(first_name, last_name),
            email: UE.build(email),
            session_version: session_version
          )
        end

        # rubocop:disable Layout/LineLength
        # @rbs (id: String, first_name: String, last_name: String, email: String, session_version: Integer) -> UserEntity
        # rubocop:enable Layout/LineLength
        def self.build_with_id(id:, first_name:, last_name:, email:, session_version:)
          new(
            id: ID.build(id),
            user_name: UN.build(first_name, last_name),
            email: UE.build(email),
            session_version: session_version
          )
        end

        # rubocop:disable Layout/LineLength
        # @rbs (user: Domain::Entity::User::UserEntity, auth_user: Domain::Entity::Auth::AuthUserEntity) -> {user_name: Domain::ValueObject::User::UserName, email: Domain::ValueObject::User::UserEmail, auth_user:{email: Domain::ValueObject::User::UserEmail, password_digest: Domain::ValueObject::AuthUser::PasswordDigest}}
        # rubocop:enable Layout/LineLength
        def self.build_with_auth_user(user:, auth_user:)
          {
            user_name: user.user_name,
            email: user.email,
            auth_user: {
              email: auth_user.email,
              password_digest: auth_user.password_digest
            }
          }
        end

        private

        # @rbs (first_name: String?, last_name: String?, email: String?) -> bool
        def no_changes?(first_name:, last_name:, email:)
          UtilMethod.nil_or_empty?(first_name) &&
            UtilMethod.nil_or_empty?(last_name) &&
            UtilMethod.nil_or_empty?(email)
        end

        # @rbs (first_name: String?, last_name: String?) -> void
        def update_user_name(first_name:, last_name:)
          new_first_name = UtilMethod.nil_or_empty?(first_name) ? user_name.first_name : first_name.to_s
          new_last_name = UtilMethod.nil_or_empty?(last_name) ? user_name.last_name : last_name.to_s
          @user_name = ::Domain::ValueObject::User::UserName.build(new_first_name, new_last_name)
        end

        # @rbs (email: String?) -> void
        def update_email(email:)
          new_email = UtilMethod.nil_or_empty?(email) ? self.email.value : email.to_s
          @email = ::Domain::ValueObject::User::UserEmail.build(new_email)
        end
      end
    end
  end
end
