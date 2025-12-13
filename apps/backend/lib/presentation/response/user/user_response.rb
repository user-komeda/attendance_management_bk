# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module User
      class UserResponse < Presentation::Response::BaseResponse
        attr_reader :id, :first_name, :last_name, :email # :String

        # @rbs (id: String, first_name: String, last_name: String, email: String) -> void
        def initialize(id:, first_name:, last_name:, email:)
          super()
          @id = id
          @first_name = first_name
          @last_name = last_name
          @email = email
        end

        # @rbs (::Application::Dto::User::UserDto user) -> Hash[Symbol, String]
        def self.build(user)
          new(
            id: user.id,
            first_name: user.first_name,
            last_name: user.last_name,
            email: user.email
          ).to_h
        end

        # @rbs (Array[::Application::Dto::User::UserDto] user_list) -> Array[Hash[Symbol, String]]
        def self.build_from_array(user_list)
          user_list.map do |user|
            build(user)
          end
        end

        # @rbs () -> {id: String, first_name: String, last_name: String, email: String }
        def to_h
          {
            id: id,
            first_name: first_name,
            last_name: last_name,
            email: email
          }
        end
      end
    end
  end
end
