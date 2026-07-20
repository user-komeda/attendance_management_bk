# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module ContentApi
      class ContentResponse < Presentation::Response::BaseResponse
        attr_reader :id, :content_api_id, :content_id, :status, :data,
                    :published_at, :closed_at, :created_by_id, :updated_by_id

        # : untyped

        # @rbs (params: Hash[Symbol, untyped]) -> void
        def initialize(params:)
          super()
          @id = params[:id]
          @content_api_id = params[:content_api_id]
          @content_id = params[:content_id]
          @status = params[:status]
          @data = params[:data]
          @published_at = params[:published_at]
          @closed_at = params[:closed_at]
          @created_by_id = params[:created_by_id]
          @updated_by_id = params[:updated_by_id]
        end

        # @rbs (content: untyped) -> Hash[Symbol, untyped]
        def self.build(content:)
          new(params: {
                id: content.id,
                content_api_id: content.content_api_id,
                content_id: content.content_id,
                status: content.status,
                data: content.data,
                published_at: content.published_at,
                closed_at: content.closed_at,
                created_by_id: content.created_by_id,
                updated_by_id: content.updated_by_id
              }).to_h
        end

        # @rbs (content_list: Array[untyped]) -> Array[Hash[Symbol, untyped]]
        def self.build_from_array(content_list:)
          content_list.map do |content|
            build(content: content)
          end
        end

        # @rbs () -> Hash[Symbol, untyped]
        def to_h
          {
            id: id,
            content_api_id: content_api_id,
            content_id: content_id,
            status: status,
            data: data,
            published_at: published_at,
            closed_at: closed_at,
            created_by_id: created_by_id,
            updated_by_id: updated_by_id
          }
        end
      end
    end
  end
end
