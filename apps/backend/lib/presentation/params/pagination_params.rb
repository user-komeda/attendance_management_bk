# frozen_string_literal: true
# rbs_inline: enabled

module Presentation
  module Params
    class PaginationParams < BaseParams
      # rubocop:disable all
      attr_reader :page, :per_page #: Integer
      # rubocop:enable all

      # @rbs (page: Integer, per_page: Integer) -> void
      def initialize(page:, per_page:)
        super()
        @page = page
        @per_page = per_page
      end

      # @rbs (Hash[Symbol, untyped] params) -> PaginationParams
      def self.build(params)
        new(
          page: params[:page] ? params[:page].to_i : Constant::Pagination::DEFAULT_PAGE_NUMBER,
          per_page: params[:per_page] ? params[:per_page].to_i : Constant::Pagination::DEFAULT_PAGE_SIZE
        )
      end
    end
  end
end
