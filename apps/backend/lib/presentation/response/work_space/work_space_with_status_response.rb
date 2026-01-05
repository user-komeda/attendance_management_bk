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
        # @rbs (status_list: Array[String], work_spaces: Array[Application::Dto::WorkSpace::WorkSpaceDto]) -> Array[Hash[Symbol, String]]
        # rubocop:enable all
        def self.build_from_array(status_list:, work_spaces:)
          work_spaces.zip(status_list).map do |work_space, status|
            next if work_space.nil? || status.nil?

            build(status: status, work_space: work_space)
          end.compact
        end

        # @rbs () -> {id: String, name: String, slug: String ,status: String}
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
