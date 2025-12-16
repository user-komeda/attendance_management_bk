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
        # rubocop:enable all

        # rubocop:disable Layout/LineLength
        # @rbs (user_name: ::Domain::ValueObject::User::UserName, email: ::Domain::ValueObject::User::UserEmail, ?id: ::Domain::ValueObject::IdentityId?) -> void
        # rubocop:enable Layout/LineLength
        def initialize(user_name:, email:, id: nil)
          @id = id
          @user_name = user_name
          @email = email
        end

        # @rbs (first_name: String?, last_name: String?, email: String?) -> void
        def change(first_name:, last_name:, email:)
          if UtilMethod.nil_or_empty?(first_name) &&
             UtilMethod.nil_or_empty?(last_name) &&
             UtilMethod.nil_or_empty?(email)
            return
          end

          # @type var new_first_name: String
          new_first_name = UtilMethod.nil_or_empty?(first_name) ? user_name.first_name : first_name

          # @type var new_last_name: String
          new_last_name = UtilMethod.nil_or_empty?(last_name) ? user_name.last_name : last_name

          # @type var new_email: String
          new_email = UtilMethod.nil_or_empty?(email) ? self.email.value : email

          @user_name = ::Domain::ValueObject::User::UserName.build(new_first_name, new_last_name)
          @email = ::Domain::ValueObject::User::UserEmail.build(new_email)
        end

        # @rbs (first_name: String, last_name: String, email: String) -> UserEntity
        def self.build(first_name:, last_name:, email:)
          new(
            user_name: UN.build(first_name, last_name),
            email: UE.build(email)
          )
        end

        # @rbs (id: String, first_name: String, last_name: String, email: String) -> UserEntity
        def self.build_with_id(id:, first_name:, last_name:, email:)
          new(
            id: ID.build(id),
            user_name: UN.build(first_name, last_name),
            email: UE.build(email)
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
      end
    end
  end
end
