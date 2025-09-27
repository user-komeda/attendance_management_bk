# frozen_string_literal: true

DB_URLS = {
  'development' => Secrets.fetch('DB_URL', project_id: '7f77ea6e-c225-4c3a-844e-039f6467f07f', environment: 'dev'),
  'test' => Secrets.fetch('DB_URL', project_id: '7f77ea6e-c225-4c3a-844e-039f6467f07f', environment: 'dev'),
  'production' => Secrets.fetch('DB_URL', project_id: '7f77ea6e-c225-4c3a-844e-039f6467f07f', environment: 'dev')
}.freeze

SCHEMA_DIR = 'schema/tables'

namespace :db do
  desc 'Export schema from DB into split files'
  task :schema_export do
    env = ENV['RACK_ENV'] || 'development'
    db_url = DB_URLS.fetch(env)
    puts "[#{env}] Exporting schema from DB: #{db_url}"
    sh "bundle exec ridgepole -c '#{db_url}' --export --split -o #{SCHEMA_DIR}"
  end

  desc 'Apply schema to DB from split files'
  task :schema_apply do
    env = ENV['RACK_ENV'] || 'development'
    db_url = DB_URLS.fetch(env)
    puts "[#{env}] Applying schema to DB: #{db_url}"
    sh "bundle exec ridgepole -c '#{db_url}' --apply --split -f #{SCHEMA_DIR}"
  end

  desc 'Dry-run schema apply'
  task :schema_dryrun do
    env = ENV['RACK_ENV'] || 'development'
    db_url = DB_URLS.fetch(env)
    puts "[#{env}] Dry-run applying schema to DB: #{db_url}"
    sh "bundle exec ridgepole -c '#{db_url}' --apply --split -f #{SCHEMA_DIR} --dry-run"
  end
end
