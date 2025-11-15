# frozen_string_literal: true

require 'rubycritic/rake_task'

namespace :code_quality do
  task all: %i[typecheck lint test lint]

  task :quality do
    sh 'rubycritic --minimum-score 10 --no-browser'
  end

  task :lint do
    sh 'bundle exec rubocop -a --parallel --quit'
  rescue RuntimeError
    puts "RuboCop finished with some offenses (but task won't fail)"
  end

  task :typecheck do
    sh ' bundle exec rbs-inline lib/ helper/  --output && bundle exec steep check'
  end

  task :test do
    sh 'bundle exec rspec'
  end
end
