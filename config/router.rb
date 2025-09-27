# frozen_string_literal: true

require 'sinatra/base'
require_relative './root'
require_relative './sinatra_settings'
require_relative './sinatra_error_handler'

# Sinatraアプリ本体
class Main < Sinatra::Base
  extend RouteHelper
  helpers RouteHelper
  helpers ResponseHelper
  register SinatraSettings
  register SinatraErrorHandler

  Root::ROUTE_CONFIG.each do |route|
    route_resources(route)
  end
end
