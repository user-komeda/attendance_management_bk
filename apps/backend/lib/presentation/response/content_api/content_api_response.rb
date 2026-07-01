# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module ContentApi
      class ContentApiResponse < Presentation::Response::BaseResponse
        # rubocop:disable all
        attr_reader :id, :work_space_id, :name, :endpoint, :api_type #: String
        # rubocop:enable all

        # @rbs (id: String, work_space_id: String, name: String, endpoint: String, api_type: String) -> void
        def initialize(id:, work_space_id:, name:, endpoint:, api_type:)
          super()
          @id = id
          @work_space_id = work_space_id
          @name = name
          @endpoint = endpoint
          @api_type = api_type
        end

        # @rbs (content_api: untyped) -> Hash[Symbol, String]
        def self.build(content_api:)
          new(
            id: content_api.id,
            work_space_id: content_api.work_space_id,
            name: content_api.name,
            endpoint: content_api.endpoint,
            api_type: content_api.api_type
          ).to_h
        end

        # @rbs (content_api_list: Array[untyped]) -> Array[Hash[Symbol, String]]
        def self.build_from_array(content_api_list:)
          content_api_list.map do |content_api|
            build(content_api: content_api)
          end
        end

        # @rbs () -> {id: String, work_space_id: String, name: String, endpoint: String, api_type: String}
        def to_h
          {
            id: id,
            work_space_id: work_space_id,
            name: name,
            endpoint: endpoint,
            api_type: api_type
          }
        end
      end
    end
  end
end
