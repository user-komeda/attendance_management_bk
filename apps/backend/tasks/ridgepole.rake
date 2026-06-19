# frozen_string_literal: true

SCHEMA_DIR = 'schema/tables'
DB_URL = AppEnv.get['DB_URL']
SCHEMA_APPLY_LOCK_FILE = 'tmp/db_schema_apply.lock'

def with_schema_apply_lock
  FileUtils.mkdir_p(File.dirname(SCHEMA_APPLY_LOCK_FILE))

  File.open(SCHEMA_APPLY_LOCK_FILE, File::RDWR | File::CREAT, 0o644) do |file|
    file.flock(File::LOCK_EX)
    yield
  ensure
    file.flock(File::LOCK_UN)
  end
end

namespace :db do
  desc 'Export schema from DB into split files'
  task :schema_export do
    sh "bundle exec ridgepole -c '#{DB_URL}' --export --split -o #{SCHEMA_DIR}"
  end

  desc 'Apply schema to DB from split files'
  task :schema_apply do
    ENV['RACK_ENV'] = 'local'

    with_schema_apply_lock do
      sh "bundle exec ridgepole -c '#{DB_URL}' --apply --split -f #{SCHEMA_DIR}"
    end
  end

  desc 'Dry-run schema apply'
  task :schema_dryrun do
    sh "bundle exec ridgepole -c '#{DB_URL}' --apply --split -f #{SCHEMA_DIR} --dry-run"
  end
end
