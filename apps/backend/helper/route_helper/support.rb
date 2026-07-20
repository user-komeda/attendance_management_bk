# frozen_string_literal: true

module RouteHelper
  module Support
    private

    def validate_parent_id!(parent)
      return unless parent

      validate_id!(params[:work_space_id], parent[:id_format])
    end

    def validate_id!(id, id_format)
      return unless id_format
      return if id_format.match?(id.to_s)

      raise ::Presentation::Exception::BadRequestException.new(message: 'Invalid id format')
    end

    def route_path(route)
      method, path, controller, action = route.values_at(:http_method, :path, :controller, :action)
      code = route.fetch(:code, 200)

      send(method, path) do
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
end
