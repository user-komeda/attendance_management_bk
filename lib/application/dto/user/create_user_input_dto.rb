# frozen_string_literal: true

module Application
  module Dto
    module User
      class CreateUserInputDto < InputBaseDto
        attr_reader :first_name, :last_name, :email

        def initialize(params)
          super()
          @first_name = params[:first_name]
          @last_name = params[:last_name]
          @email = params[:email]
        end

        def convert_to_entity
          ::Domain::Entity::User::UserEntity.build(first_name: first_name, last_name: last_name, email: email)
        end
      end
    end
  end
end
