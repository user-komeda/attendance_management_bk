# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module User
      class UserDto < Application::Dto::BaseDto
        # rubocop:disable all
        attr_reader :id, :first_name, :last_name, :email, :session_version #: String
        # rubocop:enable all

        private_class_method :new

        # @rbs (first_name: String, last_name: String, email: String, session_version: Integer?, ?id: String?) -> void
        def initialize(first_name:, last_name:, email:, session_version: nil, id: nil)
          super()
          @id = id
          @first_name = first_name
          @last_name = last_name
          @email = email
          @session_version = session_version
        end

        # @rbs (user_entity: Domain::Entity::User::UserEntity) -> UserDto
        def self.build(user_entity:)
          new(
            id: user_entity.id.value,
            first_name: user_entity.user_name.first_name,
            last_name: user_entity.user_name.last_name,
            email: user_entity.email.value,
            session_version: user_entity.session_version
          )
        end

        # @rbs (user_list: Array[::Domain::Entity::User::UserEntity]) -> Array[UserDto]
        def self.build_from_array(user_list:)
          user_list.map do |user|
            build(user_entity: user)
          end
        end
      end
    end
  end
end
