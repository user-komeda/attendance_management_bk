# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module User
      class UpdateUserUseCase < UserBaseUseCase
        # @rbs (args: ::Application::Dto::User::UpdateUserInputDto) -> ::Application::Dto::User::UserDto
        def invoke(args:)
          caller = resolve(KEY)
          user = caller.get_by_id(id: args.id)
          raise ::Application::Exception::NotFoundException.new(message: 'user not found') if user.nil?

          user.change(first_name: args.first_name, last_name: args.last_name, email: args.email)
          updated_user = caller.update(user_entity: user)
          USER_DTO.build(user_entity: updated_user)
        end
      end
    end
  end
end
