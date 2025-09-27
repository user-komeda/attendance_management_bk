# frozen_string_literal: true

module Presentation
  module Controller
    module User
      class UserController < UserControllerBase
        def index
          user_list = invoke_use_case(:get_all)
          RESPONSE.build_from_array(user_list)
        end

        def show(id)
          raise ArgumentError, '文字列が空です' if ::UtilMethod.nil_or_empty(id)

          user = invoke_use_case(:get_detail, id)
          RESPONSE.build(user)
        end

        def create(params)
          create_user_request = build_request(params, CREATE_REQUEST)
          user = invoke_use_case(:create_user, create_user_request.convert_to_dto)
          RESPONSE.build(user)
        end

        def update(params, id)
          params[:id] = id
          update_user_request = build_request(params, UPDATE_REQUEST)
          user = invoke_use_case(:update_user, update_user_request.convert_to_dto)
          RESPONSE.build(user)
        end

        def destroy(id)
          raise ArgumentError, '文字列が空です' if ::UtilMethod.nil_or_empty(id)
        end
      end
    end
  end
end
