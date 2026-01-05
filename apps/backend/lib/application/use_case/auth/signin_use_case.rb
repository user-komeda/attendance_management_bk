# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module Auth
      class SigninUseCase < AuthBaseUseCase
        # @rbs (args: ::Application::Dto::Auth::SigninInputDto) -> ::Application::Dto::Auth::AuthOutputDto
        def invoke(args:)
          auth_repository = resolve(AUTH_REPOSITORY_KEY)
          auth_service = resolve(SERVICE_KEY)
          auth_user = auth_repository.find_by_email(email: args.email)
          unless auth_user && auth_service.can_login?(auth_user: auth_user, password: args.password)
            raise Application::Exception::AuthenticationFailedException.new(
              message: 'invalid email or password'
            )
          end
          AUTH_OUTPUT_DTO.build(
            id: auth_user.id.value,
            user_id: auth_user.user_id
          )
        end
      end
    end
  end
end
