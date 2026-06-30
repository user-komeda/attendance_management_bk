# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module ContentApi
      class ContentApiWithContentsResponse < Presentation::Response::BaseResponse
        # rubocop:disable all
        attr_reader :id #: String
        attr_reader :content_api #: Hash[Symbol, untyped]
        attr_reader :contents #: Array[Hash[Symbol, untyped]]
        # rubocop:enable all

        # @rbs (id: String, content_api: Hash[Symbol, untyped], contents: Array[Hash[Symbol, untyped]]) -> void
        def initialize(id:, content_api:, contents:)
          super()
          @id = id
          @content_api = content_api
          @contents = contents
        end

        # @rbs (id: String, content_api: untyped, contents: Array[untyped]) -> Hash[Symbol, untyped]
        def self.build(id:, content_api:, contents:)
          new(
            id: id,
            content_api: ContentApiResponse.build(content_api: content_api),
            contents: ContentResponse.build_from_array(content_list: contents)
          ).to_h
        end

        # @rbs () -> {id: String, content_api: Hash[Symbol, untyped], contents: Array[Hash[Symbol, untyped]]}
        def to_h
          {
            id: id,
            content_api: content_api,
            contents: contents
          }
        end
      end
    end
  end
end
