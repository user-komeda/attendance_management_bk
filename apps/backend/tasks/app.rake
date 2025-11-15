# frozen_string_literal: true

namespace :app do
  desc 'Run Sinatra app with Infisical environment'
  task :start do
    ENV['RACK_ENV'] = 'local_dev'

    port = Secrets.get('PORT')
    host = Secrets.get('HOST')

    sh "bundle exec rackup -p #{port} -o #{host}"
  end

  task :start_local do
    ENV['RACK_ENV'] = 'local'

    port = Secrets.get('PORT')
    host = Secrets.get('HOST')

    sh "bundle exec rackup -p #{port} -o #{host}"
  end

  task :start_dev do
    ENV['RACK_ENV'] = 'dev'
    port = Secrets.get('PORT')
    host = Secrets.get('HOST')

    sh "bundle exec rackup -p #{port} -o #{host}"
  end
  task :start_prod do
    ENV['RACK_ENV'] = 'prod'
    port = Secrets.get('PORT')
    host = Secrets.get('HOST')

    sh "bundle exec rackup -p #{port} -o #{host}"
  end
end
