namespace :app do
  desc 'Run Sinatra app with Infisical environment'
  task :start do
    port = Secrets::get('PORT')
    host = Secrets::get('HOST')

    sh "bundle exec rackup -p #{port} -o #{host}"
  end
end