# frozen_string_literal: true

module RouteHelper
  DEFAULT_ACTIONS = %i[index show create update destroy].freeze

  module Support
    private

    def validate_parent_id!(parent)
      return unless parent

      validate_id!(params[:work_space_id], parent[:id_format])
    end

    def merge_workspace_id(body_params, parent)
      return body_params unless parent

      body_params.merge(work_space_id: params[:work_space_id])
    end

    def destroy_with_parent(controller, parent)
      return controller.new.destroy(params[:id]) unless parent

      controller.new.destroy(params[:id], params[:work_space_id])
    end

    def validate_id!(id, id_format)
      return if id_format.nil?
      return if id_format.match?(id.to_s)

      raise ::Presentation::Exception::BadRequestException.new(message: 'Invalid id format')
    end

    def route_path(route)
      method = route[:http_method]
      path = route[:path]
      controller = route[:controller]
      action = route[:action]
      code = route.fetch(:code, 200)

      result = send(method, path) do
        result = controller.new.public_send(action, parse_params(request))
        respond_with_data(status_code: code, id: result[:id], data: result)
      end
    end

    # @rbs (untyped request) -> Hash[Symbol, untyped]
    def parse_params(request)
      begin
        payload = JSON.parse(request.body.read, symbolize_names: true)
      rescue JSON::ParserError
        # :nocov:
        halt 400, { error: 'Invalid JSON format' }.to_json
        # :nocov:
      end
      payload
    end
  end

  include Support

  def route_resources(route)
    resource_name = route[:resource_name]
    controller = route[:controller]
    only = route[:only] || DEFAULT_ACTIONS
    id_format = route[:id_format]
    parent = route[:parent_resource]
    # :nocov:
    base_path = if parent
                  "/#{parent[:name]}/(?<work_space_id>[^/]+)/#{resource_name}"
                else
                  resource_name.empty? ? '' : "/#{resource_name}"
                end
    # :nocov:
    only.each do |action|
      define_route(action, base_path, controller, resource_name, id_format: id_format, parent: parent)
    end
  end

  private

  def define_route(action, base_path, controller, resource_name, options = {})
    id_format = options[:id_format]
    parent = options[:parent]

    case action
    when :index then define_index_route(base_path, controller)
    when :show then define_show_route(base_path, controller, id_format, parent)
    when :create then define_create_route(base_path, controller, resource_name, parent)
    when :update then define_update_route(base_path, controller, id_format, parent)
    when :destroy then define_destroy_route(base_path, controller, resource_name, id_format, parent)
    else
      # :nocov:
      raise NoMatchingPatternError
      # :nocov:
    end
  end

  def define_index_route(base_path, controller)
    get %r{#{base_path}/?} do
      controller_instance = controller.new
      result = if controller_instance.method(:index).arity.zero?
                 controller_instance.index
               else
                 controller_instance.index(params)
               end
      respond_with_data(data: result)
    end
  end

  def define_show_route(base_path, controller, id_format, parent = nil)
    get %r{#{base_path}/(?<id>[^/]+)/?} do
      validate_id!(params[:work_space_id], parent[:id_format]) if parent
      validate_id!(params[:id], id_format)
      result = controller.new.show(params[:id])
      respond_with_data(data: result)
    end
  end

  def define_create_route(base_path, controller, resource_name, parent = nil)
    post %r{#{base_path}/?} do
      validate_id!(params[:work_space_id], parent[:id_format]) if parent
      body_params = parse_params(request)
      merged = parent ? body_params.merge(work_space_id: params[:work_space_id]) : body_params
      result = controller.new.create(merged)
      respond_with_data(status_code: 201, id: result[:id], data: result, resource_name: resource_name)
    end
  end

  def define_update_route(base_path, controller, id_format, parent = nil)
    patch %r{#{base_path}/(?<id>[^/]+)/?} do
      validate_parent_id!(parent)
      validate_id!(params[:id], id_format)
      merged = merge_workspace_id(parse_params(request), parent)
      result = controller.new.update(merged, params[:id])
      respond_with_data(status_code: 204, id: result[:id])
    end
  end

  def define_destroy_route(base_path, controller, resource_name, id_format, parent = nil)
    delete %r{#{base_path}/(?<id>[^/]+)/?} do
      validate_parent_id!(parent)
      validate_id!(params[:id], id_format)
      id = destroy_with_parent(controller, parent)
      respond_with_data(status_code: 204, id: id, resource_name: resource_name)
    end
  end
end
