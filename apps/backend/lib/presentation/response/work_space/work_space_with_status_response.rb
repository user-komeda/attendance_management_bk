# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module WorkSpace
      class WorkSpaceWithStatusResponse < BaseResponse
        # rubocop:disable all
        attr_reader :id #: String
        attr_reader :name #: String
        attr_reader :slug #: String
        attr_reader :status #: String
        # rubocop:enable all

        # @rbs (id: String, name: String, slug: String, status: String) -> void
        # rubocop:enable all
        def initialize(id:, name:, status:, slug:)
          super()
          @id = id
          @name = name
          @slug = slug
          @status = status
        end

        # @rbs (status: String, work_space: Application::Dto::WorkSpace::WorkSpaceDto) -> Hash[Symbol, String]
        def self.build(status:, work_space:)
          new(
            id: work_space.id,
            name: work_space.name,
            slug: work_space.slug,
            status: status
          ).to_h
        end

        # rubocop:disable all
        # @rbs (status_list: Array[String], work_spaces: Array[Application::Dto::WorkSpace::WorkSpaceDto], pagination: { page: Integer, per_page: Integer }, total_count: Integer, ?search_query: String?) -> Hash[Symbol, untyped]
        # rubocop:enable all
        def self.build_from_array(status_list:, work_spaces:, pagination:, total_count:, search_query: nil)
          data = build_data(work_spaces: work_spaces, status_list: status_list)

          build_paginated_response(
            data: data,
            page: pagination[:page],
            per_page: pagination[:per_page],
            total_count: total_count,
            additional_meta: { search_query: search_query }
          )
        end

        # rubocop:disable all
        # @rbs (work_spaces: Array[Application::Dto::WorkSpace::WorkSpaceDto], status_list: Array[String]) -> Array[Hash[Symbol, String]]
        # rubocop:enable all
        def self.build_data(work_spaces:, status_list:)
          work_spaces.zip(status_list).filter_map do |work_space, status|
            next if work_space.nil? || status.nil?

            build(status: status, work_space: work_space)
          end
        end

        private_class_method :build_data

        # @rbs () -> Hash[Symbol, String]
        def to_h
          {
            id: id,
            name: name,
            slug: slug,
            status: status
          }
        end
      end
    end
  end
end
