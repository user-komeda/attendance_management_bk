# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module ContentApi
      class UpdateContentApiWithFieldsInputDto < InputBaseDto
        # rubocop:disable all
        attr_reader :id, :work_space_id #: String
        attr_reader :content_api #: ::Application::Dto::ContentApi::UpdateContentApiInputDto
        attr_reader :fields #: Array[::Application::Dto::ContentApi::CreateFieldInputDto]
        # rubocop:enable all

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
