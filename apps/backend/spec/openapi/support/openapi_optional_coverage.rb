# frozen_string_literal: true

require 'yaml'

module OpenapiOptionalCoverage
  class << self
    def touched
      @touched ||= Set.new
    end

    def expected
      @expected ||= expected_optional_items
    end

    def touch_schema_properties(schema_name, value)
      return touched unless value.is_a?(Hash)

      value.each_key do |property_name|
        touched.add("schema:#{schema_name}.#{property_name}")
      end
      touched
    end

    def touch_parameters(path_file_name, method, parameter_location, values)
      return touched unless values.is_a?(Hash)

      values.each_key do |parameter_name|
        touched.add("parameter:#{path_file_name}:#{method}:#{parameter_location}.#{parameter_name}")
      end
      touched
    end

    def report!
      missing = expected - touched

      return if missing.empty?

      raise <<~MESSAGE
        OpenAPI optional coverage is incomplete.

        Missing optional items:
        #{missing.to_a.sort.map { |item| "  - #{item}" }.join("\n")}
      MESSAGE
    end

    private

    def expected_optional_items
      Set.new.tap do |items|
        collect_optional_schema_properties(items)
        collect_optional_parameters(items)
      end
    end

    def collect_optional_schema_properties(items)
      schema_dir = File.join(ROOT_DIR, 'openApi', 'components', 'schemas')

      Dir.glob(File.join(schema_dir, '*.yaml')).each do |schema_file|
        schema_name = File.basename(schema_file, '.yaml')
        schema = YAML.safe_load_file(schema_file, aliases: true)

        next unless schema.is_a?(Hash)

        properties = schema.fetch('properties', {})
        required = Array(schema['required'])

        properties.each_key do |property_name|
          next if required.include?(property_name)

          items.add("schema:#{schema_name}.#{property_name}")
        end
      end
    end

    def collect_optional_parameters(items)
      path_dir = File.join(ROOT_DIR, 'openApi', 'paths')

      Dir.glob(File.join(path_dir, '*.yaml')).each do |path_file|
        collect_parameters_from_file(items, path_file)
      end
    end

    def collect_parameters_from_file(items, path_file)
      path_file_name = File.basename(path_file)
      path_item = YAML.safe_load_file(path_file, aliases: true)

      return unless path_item.is_a?(Hash)

      path_parameters = Array(path_item['parameters'])

      path_item.each do |method, operation|
        next unless %w[get post put patch delete options head trace].include?(method)
        next unless operation.is_a?(Hash)

        collect_operation_parameters(items, path_file_name, method, path_parameters + Array(operation['parameters']))
      end
    end

    def collect_operation_parameters(items, path_file_name, method, parameters)
      parameters.each do |parameter|
        resolved = resolve_ref(parameter)
        next if resolved.fetch('required', false)

        items.add(
          "parameter:#{path_file_name}:#{method}:#{resolved.fetch('in')}.#{resolved.fetch('name')}"
        )
      end
    end

    def resolve_ref(value)
      return value unless value.is_a?(Hash) && value.key?('$ref')

      ref = value.fetch('$ref')

      YAML.safe_load_file(
        File.expand_path(File.join(ROOT_DIR, 'openApi', 'paths', ref)),
        aliases: true
      )
    end
  end

  def touch_openapi_schema_properties(schema_name, value)
    OpenapiOptionalCoverage.touch_schema_properties(schema_name, value)
  end

  def touch_openapi_query_parameters(path_file_name, method, values)
    OpenapiOptionalCoverage.touch_parameters(path_file_name, method, 'query', values)
  end

  def touch_openapi_header_parameters(path_file_name, method, values)
    OpenapiOptionalCoverage.touch_parameters(path_file_name, method, 'header', values)
  end

  def touch_openapi_cookie_parameters(path_file_name, method, values)
    OpenapiOptionalCoverage.touch_parameters(path_file_name, method, 'cookie', values)
  end
end
