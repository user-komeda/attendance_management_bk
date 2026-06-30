# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module ContentApi
      class UpdateContentApiWithFieldsInputDto < InputBaseDto
        attr_reader :id, :work_space_id, :content_api, :fields # : String

        # : String
        # : ::Application::Dto::ContentApi::UpdateContentApiInputDto
        # : Array[::Application::Dto::ContentApi::CreateFieldInputDto]

        # @rbs (params: Hash[Symbol, untyped]) -> void
        def initialize(params:)
          super()
          @id = params[:id]
          @work_space_id = params[:work_space_id]
          @content_api = params[:content_api]
          @fields = params.fetch(:fields, [])
        end
      end
    end
  end
end
