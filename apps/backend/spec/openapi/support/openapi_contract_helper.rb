# frozen_string_literal: true

require 'json'
require 'yaml'

module OpenapiContractHelper
  module RequestHelper
    def json(body)
      JSON.parse(body)
    end

    def json_headers
      {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }
    end
  end

  module FileLoader
    def openapi_schema(schema_name)
      YAML.safe_load_file(
        File.join(ROOT_DIR, 'openApi', 'components', 'schemas', "#{schema_name}.yaml"),
        aliases: true
      )
    end

    def openapi_path(path_file_name)
      YAML.safe_load_file(
        File.join(ROOT_DIR, 'openApi', 'paths', path_file_name),
        aliases: true
      )
    end
  end

  include RequestHelper
  include FileLoader

  HTTP_METHODS = %w[get post put patch delete options head trace].freeze

  def app
    OPENAPI_APP
  end

  def optional_properties(schema_name)
    optional_schema_properties(openapi_schema(schema_name))
  end

  def optional_parameters(path_file_name, method)
    path_item = openapi_path(path_file_name)
    operation = path_item.fetch(method.to_s)

    parameters = Array(path_item['parameters']) + Array(operation['parameters'])

    parameters.filter_map do |parameter|
      resolved = resolve_openapi_ref(parameter)
      next if resolved.fetch('required', false)

      {
        'name' => resolved.fetch('name'),
        'in' => resolved.fetch('in')
      }
    end
  end

  def optional_query_parameters(path_file_name, method)
    optional_parameters(path_file_name, method)
      .select { |parameter| parameter.fetch('in') == 'query' }
      .map { |parameter| parameter.fetch('name') }
  end

  def optional_header_parameters(path_file_name, method)
    optional_parameters(path_file_name, method)
      .select { |parameter| parameter.fetch('in') == 'header' }
      .map { |parameter| parameter.fetch('name') }
  end

  def optional_cookie_parameters(path_file_name, method)
    optional_parameters(path_file_name, method)
      .select { |parameter| parameter.fetch('in') == 'cookie' }
      .map { |parameter| parameter.fetch('name') }
  end

  def request_body_schema_name(path_file_name, method)
    path_item = openapi_path(path_file_name)
    operation = path_item.fetch(method.to_s)

    schema = operation
             .fetch('requestBody')
             .fetch('content')
             .fetch('application/json')
             .fetch('schema')

    ref_schema_name(schema)
  end

  def response_body_schema_name(path_file_name, method, status)
    path_item = openapi_path(path_file_name)
    operation = path_item.fetch(method.to_s)

    schema = operation
             .fetch('responses')
             .fetch(status.to_s)
             .fetch('content')
             .fetch('application/json')
             .fetch('schema')

    ref_schema_name(schema)
  end

  def optional_request_body_properties(path_file_name, method)
    schema_name = request_body_schema_name(path_file_name, method)

    return [] unless schema_name

    optional_properties(schema_name)
  end

  private

  def optional_schema_properties(schema)
    properties = schema.fetch('properties', {})
    required = Array(schema['required'])

    properties.keys - required
  end

  def ref_schema_name(schema)
    return nil unless schema.is_a?(Hash)
    return nil unless schema.key?('$ref')

    File.basename(schema.fetch('$ref'), '.yaml')
  end

  def resolve_openapi_ref(value)
    return value unless value.is_a?(Hash) && value.key?('$ref')

    ref = value.fetch('$ref')

    YAML.safe_load_file(
      File.expand_path(File.join(ROOT_DIR, 'openApi', 'paths', ref)),
      aliases: true
    )
  end
end
