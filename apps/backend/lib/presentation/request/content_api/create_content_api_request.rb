# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module ContentApi
      class CreateContentApiRequest < ContentApiBaseRequest
        # @rbs (params: { work_space_id: String, name: String, endpoint: String, api_type: String }) -> void
        def initialize(params:)
          super()
          @work_space_id = params[:work_space_id]
          @name = params[:name]
          @endpoint = params[:endpoint]
          @api_type = params[:api_type]
        end

        # @rbs () -> ::Application::Dto::ContentApi::CreateContentApiInputDto
        def convert_to_dto
          CREATE_INPUT_DTO.new(
            params: {
              work_space_id: @work_space_id,
              name: @name,
              endpoint: @endpoint,
              api_type: @api_type
            }
          )
        end

        # @rbs (params: Hash[Symbol, untyped]) -> CreateContentApiRequest
        def self.build(params:)
          validate(params: params)
          CreateContentApiRequest.new(params: {
                                        work_space_id: params[:work_space_id],
                                        name: params[:name],
                                        endpoint: params[:endpoint],
                                        api_type: params[:api_type]
                                      })
        end

        class << self
          private

          # @rbs (params: Hash[Symbol, untyped]) -> void
          def validate(params:)
            validate_or_raise!(contract: ContentApiBaseRequest::CREATE_CONTRACT, params: params)
          end
        end
      end
    end
  end
end
