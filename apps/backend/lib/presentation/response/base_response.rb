# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    class BaseResponse
      protected

      # @rbs () -> Hash[Symbol, untyped]
      def to_h
        raise NotImplementedError
      end

      class << self
        # @rbs (untyped value) -> Hash[Symbol, untyped]
        def build(value)
          raise NotImplementedError
        end

        # @rbs (Array[untyped] _value_list) -> Array[Hash[Symbol, untyped]]
        def build_from_array(_value_list)
          raise NotImplementedError
        end

        private

        # @rbs (data: Array[Hash[Symbol, untyped]], page: Integer, per_page: Integer, total_count: Integer,
        #       ?additional_meta: Hash[Symbol, untyped]) -> Hash[Symbol, untyped]
        def build_paginated_response(data:, page:, per_page:, total_count:, additional_meta: {})
          total_pages = (total_count.to_f / per_page).ceil

          {
            data: data,
            meta: {
              page: page,
              total_pages: total_pages,
              total_count: total_count,
              per_page: per_page
            }.merge(additional_meta)
          }
        end
      end
    end
  end
end
