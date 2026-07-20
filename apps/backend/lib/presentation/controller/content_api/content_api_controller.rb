# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    module ContentApi
      class ContentApiController < ContentApiControllerBase
        # @rbs (String id) -> Hash[Symbol, untyped]
        def show(id)
          raise ArgumentError if ::UtilMethod.nil_or_empty?(id)

          content_api_with_fields = invoke_use_case(:get_detail, id)
          CONTENT_API_WITH_FIELDS_RESPONSE.build(content_api_with_fields: content_api_with_fields)
        end

        # @rbs (Hash[Symbol, untyped] params) -> Hash[Symbol, untyped]
        def create(params)
          create_request = build_request(params, CREATE_REQUEST)
          content_api_with_fields = invoke_use_case(:create_content_api, create_request.convert_to_dto)

          CONTENT_API_WITH_FIELDS_RESPONSE.build(content_api_with_fields: content_api_with_fields)
        end

        # @rbs (Hash[Symbol, untyped] params, String id) -> Hash[Symbol, untyped]
        def update(params, id)
          raise ArgumentError if ::UtilMethod.nil_or_empty?(id)

          params[:id] = id
          update_request = build_request(params, UPDATE_REQUEST)
          content_api_with_fields = invoke_use_case(:update_content_api, update_request.convert_to_dto)

          CONTENT_API_WITH_FIELDS_RESPONSE.build(content_api_with_fields: content_api_with_fields)
        end

        # @rbs (String id, String work_space_id) -> void
        def destroy(id, work_space_id)
          raise ArgumentError if ::UtilMethod.nil_or_empty?(id)

          use_case_key = self.class.const_get(:USE_CASE_CONTAINER)[:delete_content_api].key
          resolve(use_case_key).invoke(arg: id, work_space_id: work_space_id)
        end
      end
    end
  end
end
