# frozen_string_literal: true

module Application
  module UseCase
    module User
      class UpdateUserUseCase < UserBaseUseCase
        def invoke(input_dto)
          pp input_dto.id
          caller = resolve(KEY)
          user = caller.get_by_id(input_dto.id)
          raise ::Application::Exception::NotFoundException.new(message: 'user not found') if user.nil?

          user.change(first_name: input_dto.first_name, last_name: input_dto.last_name, email: input_dto.email)
          updated_user = caller.update(user)
          USER_DTO.build(updated_user)
        end
      end
    end
  end
end
