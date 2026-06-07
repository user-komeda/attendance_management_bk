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
    path = request.path
    return if VerifyJwt.skip_jwt_verification?(path)

    token = VerifyJwt.parse_bearer_token(request.env['HTTP_AUTHORIZATION'])

    if VerifyJwt.bff_jwt_verification?(path)
      VerifyJwt.verify_bff_jwt(token)
      next
    end

    result = VerifyJwt.verify_user_jwt(token)
    auth_context = {
      user_id: result.user_id
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

  get '/health' do
    'OK'
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
