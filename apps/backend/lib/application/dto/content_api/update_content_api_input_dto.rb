# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module ContentApi
      class UpdateContentApiInputDto < InputBaseDto
        attr_reader :name, :endpoint, :api_type # : String

        # @rbs (params: Hash[Symbol, untyped]) -> void
        def initialize(params:)
          super()
          @name = params[:name]
          @endpoint = params[:endpoint]
          @api_type = params[:api_type]
        end
      end
    end
  end
end
