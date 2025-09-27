# frozen_string_literal: true

module Application
  module UseCase
    module User
      class GetDetailUserUseCase < Application::UseCase::User::UserBaseUseCase
        def invoke(id)
          caller = resolve(KEY)
          user = caller.get_by_id(id)
          raise ::Application::Exception::NotFoundException.new(message: 'user not found') if user.nil?

          USER_DTO.build(user)
        end
      end
    end
  end
end
