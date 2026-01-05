# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module Auth
      class SigninInputDto < InputBaseDto
        # rubocop:disable all
        attr_reader :email, :password #: String
        # rubocop:enable all

        # @rbs (params: { email: String, password: String }) -> void
        def initialize(params:)
          super()
          @email = params[:email]
          @password = params[:password]
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
