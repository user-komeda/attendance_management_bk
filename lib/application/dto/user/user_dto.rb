# frozen_string_literal: true

module Application
  module Dto
    module User
      class UserDto < Application::Dto::BaseDto
        attr_reader :id, :first_name, :last_name, :email

        private_class_method :new

        def initialize(first_name:, last_name:, email:, id: nil)
          super()
          @id = id
          @first_name = first_name
          @last_name = last_name
          @email = email
        end

        def self.build(value)
          new(
            id: value.id.value,
            first_name: value.user_name.first_name,
            last_name: value.user_name.last_name,
            email: value.email.value
          )
        end

        def self.build_from_array(user_list)
          user_list.map do |user|
            build(user)
          end
        end
      end
    end
  end
end
