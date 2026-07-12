# frozen_string_literal: true

require 'rack/protection'

module SinatraSettings
  def self.registered(app)
    apply_base_settings(app)
    app.use Rack::Protection
    register_cors_headers(app)
    register_options_route(app)
  end

  def self.apply_base_settings(app)
    app.set :environment, ENV.fetch('RACK_ENV', 'production').to_sym
    app.set :show_exceptions, false
    app.set :raise_errors, false
    app.set :dump_errors, false
    app.set :logging, true
    app.set :static_cache_control, [:public, { max_age: 3600 }]
  end

  def self.register_cors_headers(app)
    app.before do
      allowed_origin = AppEnv.get['FRONTEND_ORIGIN']
      headers['Access-Control-Allow-Origin'] = allowed_origin
      headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, PATCH, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Content-Type, Accept, Authorization, X-Requested-With'
      headers['Access-Control-Expose-Headers'] = 'Location, ETag'
      headers['Vary'] = 'Origin'
    end
  end

  def self.register_options_route(app)
    app.options '*' do
      204
    end
  end
end
