# frozen_string_literal: true

PORT = ENV.fetch('PORT', nil)
HOST = ENV.fetch('HOST', nil)
namespace :app do
  desc 'Run Sinatra app'
  task :start do
    ENV['RACK_ENV'] = 'local'
    sh "bundle exec rackup -p #{PORT} -o #{HOST}"
  end
end
