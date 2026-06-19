# frozen_string_literal: true

require 'sinatra/base'
require 'jwt'
require 'securerandom'
require_relative 'root'
require_relative 'sinatra_settings'
require_relative 'sinatra_error_handler'

class Main < Sinatra::Base
  extend RouteHelper

  helpers RouteHelper
  helpers ResponseHelper
  helpers VerifyJwt
  helpers ContextHelper
  helpers SinatraErrorHandler
  register SinatraSettings
  register SinatraErrorHandler
  SWAGGER_USER_ID = '04e8496c-6b8c-4f4f-9746-2d96a10f13ec'
  USER_JWT_EXPIRES_IN_SECONDS = 60
  BFF_JWT_EXPIRES_IN_SECONDS = 60
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

  get '/swagger/token' do
    halt 404 if ENV['RACK_ENV'] == 'production'

    content_type :json
    JSON.generate(user_token: swagger_user_token, bff_token: swagger_bff_token)
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

  private

  def swagger_user_token
    env = AppEnv.get
    now = Time.now.to_i
    JWT.encode(
      {
        typ: 'access_token',
        iss: env['JWT_ISSUER'],
        aud: env['JWT_AUDIENCE'],
        sub: SWAGGER_USER_ID,
        jti: SecureRandom.uuid,
        iat: now,
        nbf: now,
        exp: now + USER_JWT_EXPIRES_IN_SECONDS
      },
      env['JWT_SECRET'], 'HS256', { typ: 'USER_JWT' }
    )
  end

  def swagger_bff_token
    env = AppEnv.get
    now = Time.now.to_i
    JWT.encode(
      {
        typ: 'bff_assertion',
        iss: env['JWT_ISSUER'],
        aud: env['JWT_AUDIENCE'],
        iat: now,
        nbf: now,
        exp: now + BFF_JWT_EXPIRES_IN_SECONDS
      },
      env['BFF_JWT_SECRET'], 'HS256', { typ: 'BFF_JWT' }
    )
  end
end
