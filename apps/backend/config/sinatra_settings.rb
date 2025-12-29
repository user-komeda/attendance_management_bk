# frozen_string_literal: true

require 'rack/protection'

module SinatraSettings
  def self.registered(app)
    app.set :environment, :production
    app.set :show_exceptions, false
    app.set :raise_errors, false
    app.set :dump_errors, true
    app.set :logging, true
    app.set :static_cache_control, [:public, { max_age: 3600 }]

    # デフォルトで十分な保護
    app.use Rack::Protection

    # CORS
    app.before do
      headers['Access-Control-Allow-Origin'] = 'http://localhost:3000'
      headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, PATCH, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Content-Type, Accept, Authorization, X-Requested-With'
      headers['Access-Control-Expose-Headers'] = 'Location, ETag'
    end
  end
end
