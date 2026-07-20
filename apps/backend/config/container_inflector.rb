# frozen_string_literal: true

require 'dry/inflector'

class ContainerInflector < Dry::Inflector
  def camelize(input)
    super.split('::').map do |part|
      # :nocov:
      part == 'Api' ? 'API' : part.gsub('API', 'Api')
      # :nocov:
    end.join('::')
  end
end
