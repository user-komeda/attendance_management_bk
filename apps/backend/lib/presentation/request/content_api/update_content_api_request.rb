# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module ContentApi
      class UpdateContentApiRequest < ContentApiBaseRequest
        # @rbs (params: Hash[Symbol, untyped]) -> void
        def initialize(params:)
          super()
          @name = params[:name]
          @endpoint = params[:endpoint]
          @api_type = params[:api_type]
        end

        # @rbs () -> ::Application::Dto::ContentApi::UpdateContentApiInputDto
        def convert_to_dto
          ::Application::Dto::ContentApi::UpdateContentApiInputDto.new(
            params: {
              name: @name,
              endpoint: @endpoint,
              api_type: @api_type
            }
          )
        end

        # @rbs (params: Hash[Symbol, untyped]) -> UpdateContentApiRequest
        def self.build(params:)
          new(params: params)
        end
      end
    end
  end
end
