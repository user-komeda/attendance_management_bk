# rubocop:disable  Metrics/AbcSize
# rubocop:disable  Metrics/MethodLength

# frozen_string_literal: true

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
        delete "#{base_path}:id" do
          controller.new.destroy(params[:id])
          respond_with_data(status_code: 204)
        end
      else
        raise NoMatchingPatternError
      end
    end
  end

  # @rbs (untyped request) -> Hash[Symbol, untyped]
  def parse_params(request)
    begin
      payload = JSON.parse(request.body.read, symbolize_names: true)
    rescue JSON::ParserError
      halt 400, { error: 'Invalid JSON format' }.to_json
    end
    payload
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength