# frozen_string_literal: true

require 'rack/protection'

module SinatraSettings
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def self.registered(app)
    app.set :environment, ENV.fetch('RACK_ENV', 'production').to_sym
    app.set :show_exceptions, false
    app.set :raise_errors, false
    app.set :dump_errors, false
    app.set :logging, true
    app.set :static_cache_control, [:public, { max_age: 3600 }]

    app.use Rack::Protection

    app.before do
      allowed_origin = AppEnv.get['FRONTEND_ORIGIN']

      headers['Access-Control-Allow-Origin'] = allowed_origin
      headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, PATCH, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Content-Type, Accept, Authorization, X-Requested-With'
      headers['Access-Control-Expose-Headers'] = 'Location, ETag'
      headers['Vary'] = 'Origin'
    end

    app.options '*' do
      204
    end
  end

  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
