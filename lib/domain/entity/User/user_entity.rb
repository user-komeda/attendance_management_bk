# frozen_string_literal: true

module Domain
  module Entity
    module User
      class UserEntity
        ID = ::Domain::ValueObject::IdentityId.freeze
        UN = ::Domain::ValueObject::User::UserName.freeze
        UE = ::Domain::ValueObject::User::UserEmail.freeze

        attr_accessor :id, :user_name, :email

        def initialize(user_name:, email:, id: nil)
          @id = id
          @user_name = user_name
          @email = email
        end

        def change(first_name:, last_name:, email:)
          if UtilMethod.nil_or_empty(first_name) && UtilMethod.nil_or_empty(last_name) && UtilMethod.nil_or_empty(email)
            return
          end

          self.user_name = ::Domain::ValueObject::User::UserName.build(
            UtilMethod.nil_or_empty(first_name) ? user_name.first_name : first_name,
            UtilMethod.nil_or_empty(last_name) ? user_name.last_name : last_name
          )
          self.email = ::Domain::ValueObject::User::UserEmail.build(UtilMethod.nil_or_empty(email) ? self.email : email)
        end

        def self.build(first_name:, last_name:, email:)
          new(
            user_name: UN.build(first_name, last_name),
            email: UE.build(email)
          )
        end

        def self.build_from_entity(entity)
          new(
            id: ID.build(entity.id),
            user_name: UN.build(entity.first_name, entity.last_name),
            email: UE.build(entity.email)
          )
        end
      end
    end
  end
end
