# frozen_string_literal: true

PORT = AppEnv.get['PORT']
HOST = AppEnv.get['HOST']
namespace :app do
  desc 'Run Sinatra app'
  task :start do
    ENV['RACK_ENV'] = 'local'
    sh "bundle exec rackup -p #{PORT} -o #{HOST}"
  end
end
