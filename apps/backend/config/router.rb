# frozen_string_literal: true

require 'sinatra/base'
require_relative 'root'
require_relative 'sinatra_settings'
require_relative 'sinatra_error_handler'

class Main < Sinatra::Base
  extend RouteHelper

  helpers RouteHelper
  helpers ResponseHelper
  register SinatraSettings
  register SinatraErrorHandler
  # :nocov:
  get '/swagger' do
    send_file 'public/swagger.html'
  end
  # :nocov:
  # :nocov:
  get '/openapi.yaml' do
    content_type 'application/yaml'
    send_file File.join('openApi', 'openapi.yaml')
  end
  # :nocov:

  Root::ROUTE_CONFIG.each do |route|
    route_resources(route)
  end
end
