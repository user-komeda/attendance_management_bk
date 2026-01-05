# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
# rbs_inline: enabled

module RouteHelper
  DEFAULT_ACTIONS = %i[index show create update destroy].freeze

  # @rbs (Hash[Symbol, untyped] route) -> void
  def route_resources(route)
    uuid_pattern = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/i

    resource_name = route[:resource_name]
    controller = route[:controller]
    only = route[:only] || DEFAULT_ACTIONS
    # :nocov:
    base_path = resource_name.empty? ? '' : "/#{resource_name}"
    # :nocov:
    only.each do |action|
      case action
      when :index
        get %r{#{base_path}/?} do
          result = controller.new.index
          respond_with_data(data: result)
        end
      when :show
        get %r{#{base_path}/(?<id>(?i:#{uuid_pattern}))/?} do
          result = controller.new.show(params[:id])
          respond_with_data(data: result)
        end
      when :create
        post %r{#{base_path}/?} do
          result = controller.new.create(parse_params(request))
          respond_with_data(status_code: 201, id: result[:id], data: result, resource_name: resource_name)
        end
      when :update
        patch %r{#{base_path}/(?<id>(?i:#{uuid_pattern}))/?} do
          result = controller.new.update(parse_params(request), params[:id])
          respond_with_data(status_code: 204, id: result[:id])
        end
      when :destroy
        delete %r{#{base_path}/(?<id>(?i:#{uuid_pattern}))/?} do
          id = controller.new.destroy(params[:id])
          respond_with_data(status_code: 204, id: id, resource_name: resource_name)
        end
        # :nocov:
      else
        raise NoMatchingPatternError
      end
      # :nocov:
    end
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
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize
