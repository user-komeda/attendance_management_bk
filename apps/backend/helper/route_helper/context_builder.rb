# frozen_string_literal: true

module RouteHelper
  module ContextBuilder
    private

    def build_resource_context(route:)
      resource_name, controller, only, id_format, parent = route.values_at(
        :resource_name,
        :controller,
        :only,
        :id_format,
        :parent_resource
      )

      context = ResourceContext.new(
        base_path: build_base_path(resource_name: resource_name, parent: parent),
        controller: controller,
        resource_name: resource_name,
        id_format: id_format,
        parent: parent
      )

      [context, only || DEFAULT_ACTIONS]
    end

    def build_base_path(resource_name:, parent:)
      return "/#{parent[:name]}/(?<work_space_id>[^/]+)/#{resource_name}" if parent
      return '' if resource_name.empty?

      "/#{resource_name}"
    end
  end
end
