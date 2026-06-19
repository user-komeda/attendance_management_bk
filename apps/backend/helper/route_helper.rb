# frozen_string_literal: true

module RouteHelper
  DEFAULT_ACTIONS = %i[index show create update destroy].freeze

  def route_resources(route)
    resource_name = route[:resource_name]
    controller = route[:controller]
    only = route[:only] || DEFAULT_ACTIONS
    # :nocov:
    base_path = resource_name.empty? ? '' : "/#{resource_name}"
    # :nocov:
    only.each do |action|
      define_route(action, base_path, controller, resource_name)
    end
  end

  private

  def define_route(action, base_path, controller, resource_name)
    case action
    when :index then define_index_route(base_path, controller)
    when :show then define_show_route(base_path, controller)
    when :create then define_create_route(base_path, controller, resource_name)
    when :update then define_update_route(base_path, controller)
    when :destroy then define_destroy_route(base_path, controller, resource_name)
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

  def define_show_route(base_path, controller)
    get %r{#{base_path}/(?<id>[^/]+)/?} do
      validate_id!(params[:id])
      result = controller.new.show(params[:id])
      respond_with_data(data: result)
    end
  end

  def define_create_route(base_path, controller, resource_name)
    post %r{#{base_path}/?} do
      result = controller.new.create(parse_params(request))
      respond_with_data(status_code: 201, id: result[:id], data: result, resource_name: resource_name)
    end
  end

  def define_update_route(base_path, controller)
    patch %r{#{base_path}/(?<id>[^/]+)/?} do
      validate_id!(params[:id])
      result = controller.new.update(parse_params(request), params[:id])
      respond_with_data(status_code: 204, id: result[:id])
    end
  end

  def define_destroy_route(base_path, controller, resource_name)
    delete %r{#{base_path}/(?<id>[^/]+)/?} do
      validate_id!(params[:id])
      id = controller.new.destroy(params[:id])
      respond_with_data(status_code: 204, id: id, resource_name: resource_name)
    end
  end

  def validate_id!(id)
    return if uuid_pattern.match?(id.to_s)

    raise ::Presentation::Exception::BadRequestException.new(message: 'Invalid id format')
  end

  def uuid_pattern
    /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i
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
