# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module User
      class UpdateUserUseCase < UserBaseUseCase
        # @rbs (arg: ::Application::Dto::User::UpdateUserInputDto) -> ::Application::Dto::User::UserDto
        def invoke(arg:)
          caller = resolve(KEY)
          user = caller.get_by_id(id: arg.id)
          raise ::Application::Exception::NotFoundException.new(message: 'user not found') if user.nil?

          user.change(first_name: arg.first_name, last_name: arg.last_name, email: arg.email)
          updated_user = caller.update(user_entity: user)
          USER_DTO.build(user_entity: updated_user)
        end
      end
    end
  end
end
