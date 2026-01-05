# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module WorkSpace
      class UpdateWorkSpaceRequest < WorkSpaceBaseRequest
        # @rbs (params: { id: String, name: String, slug: String }) -> void
        def initialize(params:)
          super()
          @id = params[:id]
          @name = params[:name]
          @slug = params[:slug]
        end

        # @rbs () -> ::Application::Dto::WorkSpace::UpdateWorkSpaceInputDto
        def convert_to_dto
          UPDATE_INPUT_DTO.new(
            id: @id,
            name: @name,
            slug: @slug
          )
        end

        # @rbs (params: { id: String, name: String, slug: String }) -> UpdateWorkSpaceRequest
        def self.build(params:)
          validate(params: params)
          UpdateWorkSpaceRequest.new(params: params)
        end

        class << self
          private

          # @rbs (params:{ id: String, name: String, slug: String }) -> void
          def validate(params:)
            result = WorkSpaceBaseRequest::UPDATE_CONTRACT.new.call(params)
            return unless result.failure?

            raise ::Presentation::Exception::BadRequestException.new(message: result.errors.to_h.to_json)
          end
        end
      end
    end
  end
end
