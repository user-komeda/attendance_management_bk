# frozen_string_literal: true

namespace :app do
  desc 'Run Sinatra app in local_dev environment'
  task :start do
    ENV['RACK_ENV'] = 'local'

    port = Secrets.get('PORT')
    host = Secrets.get('HOST')

    sh "bundle exec rackup -p #{port} -o #{host}"
  end

  desc 'Run Sinatra app in local_dev environment'
  task :start_local_dev do
    ENV['RACK_ENV'] = 'local_dev'

    port = Secrets.get('PORT')
    host = Secrets.get('HOST')

    sh "bundle exec rackup -p #{port} -o #{host}"
  end

  desc 'Run Sinatra app in development environment'
  task :start_dev do
    ENV['RACK_ENV'] = 'dev'

    port = Secrets.get('PORT')
    host = Secrets.get('HOST')

    sh "bundle exec rackup -p #{port} -o #{host}"
  end

  desc 'Run Sinatra app in production environment'
  task :start_prod do
    ENV['RACK_ENV'] = 'prod'

    port = Secrets.get('PORT')
    host = Secrets.get('HOST')

    sh "bundle exec rackup -p #{port} -o #{host}"
  end
end
