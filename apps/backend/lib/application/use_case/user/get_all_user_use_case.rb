# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module User
      class GetAllUserUseCase < UserBaseUseCase
        # @rbs (?arg: nil) -> Array[::Application::Dto::User::UserDto]
        def invoke(arg: nil) # rubocop:disable Lint/UnusedMethodArgument
          caller = resolve(KEY)
          user_list = caller.get_all
          USER_DTO.build_from_array(user_list: user_list)
        end
      end
    end
  end
end
