# frozen_string_literal: true

module Application
  module UseCase
    module User
      class GetAllUserUseCase < UserBaseUseCase
        def invoke
          caller = resolve(KEY)
          user_list = caller.get_all
          USER_DTO.build_from_array(user_list)
        end
      end
    end
  end
end
