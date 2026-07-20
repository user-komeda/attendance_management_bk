# frozen_string_literal: true

module RouteHelper
  module ActionDefinitions
    ACTION_ROUTE_DEFINERS = {
      index: :define_index_route,
      show: :define_show_route,
      create: :define_create_route,
      update: :define_update_route,
      destroy: :define_destroy_route
    }.freeze

    private

    def define_route(action, context)
      method_name = ACTION_ROUTE_DEFINERS[action]
      raise NoMatchingPatternError unless method_name # :nocov:

      send(method_name, context)
    end

    def define_index_route(context)
      get context.collection_path do
        controller_instance = context.controller.new
        result = execute_index(controller_instance)
        respond_with_data(data: result)
      end
    end

    def define_show_route(context)
      controller = context.controller.new

      get context.id_path do
        result = with_validated_id(context) do |id|
          controller.show(id)
        end

        respond_with_data(data: result)
      end
    end

    def define_create_route(context)
      controller = context.controller.new

      post context.collection_path do
        validate_parent_id!(context.parent)
        merged = context.merge_parent_params(body_params: parse_params(request), work_space_id: params[:work_space_id])
        result = controller.create(merged)

        respond_with_data(status_code: 201, id: result[:id], data: result, resource_name: context.resource_name)
      end
    end

    def define_update_route(context)
      controller = context.controller.new

      patch context.id_path do
        merged = context.merge_parent_params(body_params: parse_params(request), work_space_id: params[:work_space_id])
        result = with_validated_id(context) do |id|
          controller.update(merged, id)
        end

        respond_with_data(status_code: 204, id: result[:id])
      end
    end

    def define_destroy_route(context)
      controller = context.controller.new

      delete context.id_path do
        deleted_id = with_validated_id(context) do |id|
          context.parent? ? controller.destroy(id, params[:work_space_id]) : controller.destroy(id)
        end

        respond_with_data(status_code: 204, id: deleted_id, resource_name: context.resource_name)
      end
    end

    def with_validated_id(context)
      id = params[:id]
      validate_parent_id!(context.parent)
      validate_id!(id, context.id_format)

      yield(id)
    end

    def execute_index(controller_instance)
      return controller_instance.index if controller_instance.method(:index).arity.zero?

      controller_instance.index(params)
    end
  end
end
