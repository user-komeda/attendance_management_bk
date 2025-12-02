# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Entity
    module User
      class UserEntity
        ID = ::Domain::ValueObject::IdentityId.freeze
        UN = ::Domain::ValueObject::User::UserName.freeze
        UE = ::Domain::ValueObject::User::UserEmail.freeze

        # @rbs @id: ::Domain::ValueObject::IdentityId?
        # @rbs @user_name: ::Domain::ValueObject::User::UserName
        # @rbs @email: ::Domain::ValueObject::User::UserEmail
        attr_accessor :id, :user_name, :email

        # rubocop:disable Layout/LineLength
        # @rbs (user_name: ::Domain::ValueObject::User::UserName, email: ::Domain::ValueObject::User::UserEmail, ?id: ::Domain::ValueObject::IdentityId?) -> void
        # rubocop:enable Layout/LineLength
        def initialize(user_name:, email:, id: nil)
          @id = id
          @user_name = user_name
          @email = email
        end

        # rubocop:disable Metrics/AbcSize
        # @rbs (first_name: String?, last_name: String?, email: String?) -> void
        def change(first_name:, last_name:, email:)
          if UtilMethod.nil_or_empty(first_name) && UtilMethod.nil_or_empty(last_name) && UtilMethod.nil_or_empty(email)
            return
          end

          # @type var new_first_name: String
          new_first_name = UtilMethod.nil_or_empty(first_name) ? user_name.first_name : first_name

          # @type var new_last_name: String
          new_last_name = UtilMethod.nil_or_empty(last_name) ? user_name.last_name : last_name

          # @type var new_email: String
          new_email = UtilMethod.nil_or_empty(email) ? self.email.value : email

          self.user_name = ::Domain::ValueObject::User::UserName.build(new_first_name, new_last_name)
          self.email = ::Domain::ValueObject::User::UserEmail.build(new_email)
        end
        # rubocop:enable Metrics/AbcSize

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
      end
    end
  end
end
