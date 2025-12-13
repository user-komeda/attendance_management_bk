# frozen_string_literal: true

require 'rubycritic/rake_task'

namespace :code_quality do
  desc 'Run typecheck, lint, test, and lint again'
  task all: %i[typecheck lint test quality]

  desc 'Run rubycritic code quality check'
  task :quality do
    sh 'rubycritic --minimum-score 95 --no-browser'
  end

  desc 'Run RuboCop lint with auto-correct'
  task :lint do
    sh 'bundle exec rubocop -a --parallel -D'
  end

  desc 'Run RBS inline generation and Steep type checking'
  task :typecheck do
    sh 'bundle exec rbs-inline lib helper  --output && bundle exec steep check'
  end

  desc 'Run RSpec tests after applying DB schema (local)'
  task :test do
    sh 'bundle exec rake db:schema_apply_local && bundle exec rspec'
  end
end
