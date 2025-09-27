# frozen_string_literal: true

require 'rack/protection'

module SinatraSettings
  def self.registered(app)
    # 基本設定
    app.set :environment, :production
    app.set :show_exceptions, false
    app.set :raise_errors, false
    app.set :dump_errors, true
    app.set :logging, true
    app.set :static_cache_control, [:public, { max_age: 3600 }]

    # セキュリティ保護
    app.use Rack::Protection # 全体的な保護
    app.use Rack::Protection::FrameOptions # Clickjacking 対策
    app.use Rack::Protection::XSSHeader # XSS ヘッダー
    app.use Rack::Protection::PathTraversal # 不正パスアクセス防止
    app.use Rack::Protection::JsonCsrf # JSON CSRF 保護
  end
end
