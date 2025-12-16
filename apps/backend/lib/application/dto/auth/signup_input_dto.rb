# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module Auth
      class SignupInputDto < InputBaseDto
        attr_reader :first_name, :last_name, :email, :password # : String

        # @rbs ({ first_name: String, last_name: String, email: String, password: String }) -> void
        def initialize(params)
          super()
          @first_name = params[:first_name]
          @last_name = params[:last_name]
          @email = params[:email]
          @password = params[:password]
        end

        # @rbs () -> ::Domain::Entity::User::UserEntity
        def convert_to_user_entity
          ::Domain::Entity::User::UserEntity.build(first_name: first_name, last_name: last_name, email: email)
        end

        # @rbs () -> ::Domain::Entity::Auth::AuthUserEntity
        def convert_to_auth_user_entity
          ::Domain::Entity::Auth::AuthUserEntity.build(password: password,
                                                       email: email)
        end
      end
    end
  end
end
