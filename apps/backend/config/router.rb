# frozen_string_literal: true

require 'sinatra/base'
require_relative 'root'
require_relative 'sinatra_settings'
require_relative 'sinatra_error_handler'

class Main < Sinatra::Base
  extend RouteHelper

  helpers RouteHelper
  helpers ResponseHelper
  helpers VerifyJwt
  helpers ContextHelper
  register SinatraSettings
  register SinatraErrorHandler

  before do
    # path = request.path
    # return if VerifyJwt.skip_jwt_verification?(path)
    # result= VerifyJwt.verify_jwt(VerifyJwt.parse_bearer_token(request.env['HTTP_AUTHORIZATION']))
    auth_context = {
      user_id: '04e8496c-6b8c-4f4f-9746-2d96a10f13ec'
    }
    ContextHelper.set_context(:auth_context, auth_context)
  end

  after do
    ContextHelper.set_context(:auth_context, nil)
  end
  # :nocov:
  get '/swagger' do
    send_file 'public/swagger.html'
  end
  # :nocov:
  # :nocov:
  get '/openapi/*' do
    relative_path = params['splat'].first
    file_path = File.expand_path(File.join('openApi', relative_path))

    halt 404, "Not Found: #{file_path}" unless File.exist?(file_path)

    content_type 'application/yaml'
    send_file file_path
  end
  # :nocov:

  Root::CUSTOM_ROUTE_CONFIG.each do |route|
    route_path(route)
  end
  Root::ROUTE_CONFIG.each do |route|
    route_resources(route)
  end
end
