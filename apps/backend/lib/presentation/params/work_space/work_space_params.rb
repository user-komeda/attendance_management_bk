# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Params
    module WorkSpace
      class WorkSpaceParams < BaseParams
        # rubocop:disable all
        attr_reader :pagination #: Presentation::Params::PaginationParams
        attr_reader :search_query #: String?
        # rubocop:enable all

        # @rbs (pagination: Presentation::Params::PaginationParams, search_query: String?) -> void
        def initialize(pagination:, search_query:)
          super()
          @pagination = pagination
          @search_query = search_query
        end

        # @rbs (Hash[Symbol, untyped] params) -> WorkSpaceParams
        def self.build(params)
          new(
            pagination: Presentation::Params::PaginationParams.build(params),
            search_query: params[:search_query]
          )
        end

        # @rbs () -> ::Application::Dto::WorkSpace::GetAllWorkSpaceInputDto
        def convert_to_dto
          Application::Dto::WorkSpace::GetAllWorkSpaceInputDto.build(
            page: pagination.page,
            per_page: pagination.per_page,
            search_query: search_query
          )
        end
      end
    end
  end
end
