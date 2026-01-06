# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module User
      class UpdateUserInputDto < InputBaseDto
        attr_reader :id, :first_name, :last_name, :email # :String
        # rubocop:enable all

        # @rbs (id: String, first_name: String, last_name: String, email: String) -> void
        def initialize(id:, first_name:, last_name:, email:)
          super()
          @id = id
          @first_name = first_name
          @last_name = last_name
          @email = email
        end

        # @rbs () -> ::Domain::Entity::User::UserEntity
        def convert_to_entity
          ::Domain::Entity::User::UserEntity.build(first_name: first_name, last_name: last_name, email: email)
        end
      end
    end
  end
end
