# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module WorkSpace
      class WorkSpaceResponse < BaseResponse
        # rubocop:disable all
        attr_reader :id, :name, :slug #: String
        # rubocop:enable all

        # @rbs (id: String, name: String, slug: String) -> void
        def initialize(id:, name:, slug:)
          super()
          @id = id
          @name = name
          @slug = slug
        end

        # @rbs (work_space: ::Application::Dto::WorkSpace::WorkSpaceDto) -> Hash[Symbol, String]
        # rubocop:enable all
        def self.build(work_space:)
          new(
            id: work_space.id,
            name: work_space.name,
            slug: work_space.slug
          ).to_h
        end

        # @rbs (work_space_list: Array[::Application::Dto::WorkSpace::WorkSpaceDto]) -> Array[Hash[Symbol, String]]
        def self.build_from_array(work_space_list:)
          work_space_list.map do |work_space|
            build(work_space: work_space)
          end
        end

        # @rbs () -> {id: String, name: String, slug: String }
        def to_h
          {
            id: id,
            name: name,
            slug: slug
          }
        end
      end
    end
  end
end
