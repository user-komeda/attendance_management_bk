# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module WorkSpace
      class CreateWorkSpaceRequest < WorkSpaceBaseRequest
        # @rbs (params: { name: String, slug: String }) -> void
        def initialize(params:)
          super()
          @name = params[:name]
          @slug = params[:slug]
        end

        # @rbs () -> ::Application::Dto::WorkSpace::CreateWorkSpaceInputDto
        def convert_to_dto
          CREATE_INPUT_DTO.new(
            params: {
              name: @name,
              slug: @slug
            }
          )
        end

        # @rbs (params: {name: String, slug: String }) -> CreateWorkSpaceRequest
        def self.build(params:)
          validate(params: params)
          CreateWorkSpaceRequest.new(params: params)
        end

        class << self
          private

          # @rbs (params: { name: String, slug: String }) -> void
          def validate(params:)
            result = WorkSpaceBaseRequest::CREATE_CONTRACT.new.call(params)
            return unless result.failure?

            raise ::Presentation::Exception::BadRequestException.new(message: result.errors.to_h.to_json)
          end
        end
      end
    end
  end
end
