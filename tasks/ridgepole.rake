# frozen_string_literal: true

DB_URLS = {
  'dev' => Secrets.get('DB_URL'),
  'test' => Secrets.get('DB_URL'),
  'production' => Secrets.get('DB_URL')
}.freeze

SCHEMA_DIR = 'schema/tables'

namespace :db do
  desc 'Export schema from DB into split files'
  task :schema_export do
    env = ENV['RACK_ENV'] || 'dev'
    db_url = DB_URLS[env]
    puts "[#{env}] Exporting schema from DB: #{db_url}"
    sh "bundle exec ridgepole -c '#{db_url}' --export --split -o #{SCHEMA_DIR}"
  end

  desc 'Apply schema to DB from split files'
  task :schema_apply do
    env = ENV['RACK_ENV'] || 'dev'
    db_url = DB_URLS.fetch(env)
    puts "[#{env}] Applying schema to DB: #{db_url}"
    sh "bundle exec ridgepole -c '#{db_url}' --apply --split -f #{SCHEMA_DIR}"
  end

  desc 'Dry-run schema apply'
  task :schema_dryrun do
    env = ENV['RACK_ENV'] || 'local'
    db_url = DB_URLS.fetch(env)
    puts "[#{env}] Dry-run applying schema to DB: #{db_url}"
    sh "bundle exec ridgepole -c '#{db_url}' --apply --split -f #{SCHEMA_DIR} --dry-run"
  end
end
