# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module User
      class CreateUserInputDto < InputBaseDto
        # @rbs @first_name: String
        # @rbs @last_name: String
        # @rbs @email: String
        attr_reader :first_name, :last_name, :email

        # @rbs ({ first_name: String, last_name: String, email: String }) -> void
        def initialize(params)
          super()
          @first_name = params[:first_name]
          @last_name = params[:last_name]
          @email = params[:email]
        end

        # @rbs () -> ::Domain::Entity::User::UserEntity
        def convert_to_entity
          ::Domain::Entity::User::UserEntity.build(first_name: first_name, last_name: last_name, email: email)
        end
      end
    end
  end
end
