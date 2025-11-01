# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    module User
      class UserController < UserControllerBase
        # @rbs () -> Array[untyped]
        def index
          user_list = invoke_use_case(:get_all)
          RESPONSE.build_from_array(user_list)
        end

        # @rbs (String id) -> untyped
        def show(id)
          raise ArgumentError, '譁・ｭ怜・縺檎ｩｺ縺ｧ縺・ if ::UtilMethod.nil_or_empty(id)

          user = invoke_use_case(:get_detail, id)
          RESPONSE.build(user)
        end

        # @rbs (Hash[Symbol, untyped] params) -> untyped
        def create(params)
          create_user_request = build_request(params, CREATE_REQUEST)
          user = invoke_use_case(:create_user, create_user_request.convert_to_dto)
          RESPONSE.build(user)
        end

        # @rbs (Hash[Symbol, untyped] params, String id) -> untyped
        def update(params, id)
          params[:id] = id
          update_user_request = build_request(params, UPDATE_REQUEST)
          user = invoke_use_case(:update_user, update_user_request.convert_to_dto)
          RESPONSE.build(user)
        end

        # @rbs (String id) -> void
        def destroy(id)
          raise ArgumentError, '譁・ｭ怜・縺檎ｩｺ縺ｧ縺・ if ::UtilMethod.nil_or_empty(id)
        end
      end
    end
  end
end