# frozen_string_literal: true

require 'rack/protection'

module SinatraSettings
  def self.registered(app)
    # 蝓ｺ譛ｬ險ｭ螳・    app.set :environment, :production
    app.set :show_exceptions, false
    app.set :raise_errors, false
    app.set :dump_errors, true
    app.set :logging, true
    app.set :static_cache_control, [:public, { max_age: 3600 }]

    app.before do
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, PATCH, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Content-Type, Accept, Authorization, X-Requested-With'
      headers['Access-Control-Expose-Headers'] = 'Location, ETag'
    end

    # OPTIONS繝ｪ繧ｯ繧ｨ繧ｹ繝茨ｼ医・繝ｪ繝輔Λ繧､繝医Μ繧ｯ繧ｨ繧ｹ繝茨ｼ峨↓蟇ｾ蠢・    app.options '*' do
      response.headers['Allow'] = 'GET, POST, PUT, PATCH, DELETE, OPTIONS'
      response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Accept, Authorization, X-Requested-With'
      response.headers['Access-Control-Allow-Origin'] = '*'
      200
    end

    # 繧ｻ繧ｭ繝･繝ｪ繝・ぅ菫晁ｭｷ
    app.use Rack::Protection # 蜈ｨ菴鍋噪縺ｪ菫晁ｭｷ
    app.use Rack::Protection::FrameOptions # Clickjacking 蟇ｾ遲・    app.use Rack::Protection::XSSHeader # XSS 繝倥ャ繝繝ｼ
    app.use Rack::Protection::PathTraversal # 荳肴ｭ｣繝代せ繧｢繧ｯ繧ｻ繧ｹ髦ｲ豁｢
  end
end
