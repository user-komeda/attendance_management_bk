# frozen_string_literal: true

SCHEMA_DIR = 'schema/tables'
DB_URL = ENV.fetch('DB_URL', nil)
namespace :db do
  desc 'Export schema from DB into split files'
  task :schema_export do
    sh "bundle exec ridgepole -c '#{DB_URL}' --export --split -o #{SCHEMA_DIR}"
  end

  desc 'Apply schema to DB from split files'
  task :schema_apply do
    ENV['RACK_ENV'] = 'local'
    sh "bundle exec ridgepole -c '#{DB_URL}' --apply --split -f #{SCHEMA_DIR}"
  end

  desc 'Dry-run schema apply'
  task :schema_dryrun do
    sh "bundle exec ridgepole -c '#{DB_URL}' --apply --split -f #{SCHEMA_DIR} --dry-run"
  end
end
