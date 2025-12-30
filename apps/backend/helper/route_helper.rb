# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
# rbs_inline: enabled

module RouteHelper
  DEFAULT_ACTIONS = %i[index show create update destroy].freeze

  # @rbs (Hash[Symbol, untyped] route) -> void
  def route_resources(route)
    base_path = route[:base_path]
    controller = route[:controller]
    only = route[:only] || DEFAULT_ACTIONS
    only.each do |action|
      case action
      when :index
        get base_path do
          result = controller.new.index
          respond_with_data(data: result)
        end
      when :show
        get "#{base_path}:id" do
          result = controller.new.show(params[:id])
          respond_with_data(data: result)
        end
      when :create
        post base_path do
          result = controller.new.create(parse_params(request))
          respond_with_data(status_code: 201, id: result[:id], data: result)
        end
      when :update
        patch "#{base_path}:id" do
          result = controller.new.update(parse_params(request), params[:id])
          respond_with_data(status_code: 204, id: result[:id])
        end
      when :destroy
        # :nocov:
        delete "#{base_path}:id" do
          controller.new.destroy(params[:id])
          respond_with_data(status_code: 204)
        end
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
