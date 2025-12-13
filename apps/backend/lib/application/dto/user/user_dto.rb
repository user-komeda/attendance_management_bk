# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module User
      class UserDto < Application::Dto::BaseDto
        attr_reader :id, :first_name, :last_name, :email # : String

        private_class_method :new

        # @rbs (first_name: String, last_name: String, email: String, ?id: String?) -> void
        def initialize(first_name:, last_name:, email:, id: nil)
          super()
          @id = id
          @first_name = first_name
          @last_name = last_name
          @email = email
        end

        # @rbs (::Domain::Entity::User::UserEntity value) -> UserDto
        def self.build(value)
          new(
            id: value.id.value,
            first_name: value.user_name.first_name,
            last_name: value.user_name.last_name,
            email: value.email.value
          )
        end

        # @rbs (Array[::Domain::Entity::User::UserEntity] user_list) -> Array[UserDto]
        def self.build_from_array(user_list)
          user_list.map do |user|
            build(user)
          end
        end
      end
    end
  end
end
