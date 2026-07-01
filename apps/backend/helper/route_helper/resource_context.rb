# frozen_string_literal: true

module RouteHelper
  ResourceContext = Struct.new(:base_path, :controller, :resource_name, :id_format, :parent, keyword_init: true) do
    def parent?
      !!parent
    end

    def id_path
      %r{#{base_path}/(?<id>[^/]+)/?}
    end

    def collection_path
      %r{#{base_path}/?}
    end

    def merge_parent_params(body_params:, work_space_id:)
      return body_params unless parent?

      body_params.merge(work_space_id: work_space_id)
    end
  end
end
