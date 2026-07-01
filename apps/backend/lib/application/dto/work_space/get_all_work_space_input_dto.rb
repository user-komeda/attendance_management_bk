# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module WorkSpace
      class GetAllWorkSpaceInputDto < InputBaseDto
        # rubocop:disable all
        attr_reader :page, :per_page #: Integer
        attr_reader :search_query #: String?
        # rubocop:enable all

        # @rbs (page: Integer, per_page: Integer, search_query: String?) -> void
        def initialize(page:, per_page:, search_query:)
          super()
          @page = page
          @per_page = per_page
          @search_query = search_query
        end

        # @rbs (page: Integer, per_page: Integer, search_query: String?) -> GetAllWorkSpaceInputDto
        def self.build(page:, per_page:, search_query:)
          new(page: page, per_page: per_page, search_query: search_query)
        end

        # @rbs () -> ::Domain::Entity::DomainEntity
        def convert_to_entity
          raise NotImplementedError
        end
      end
    end
  end
end
