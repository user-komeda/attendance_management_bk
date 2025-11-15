# frozen_string_literal: true

module Secrets
  def self.get(name)
    env = ENV['RACK_ENV']
    if %w[local local_dev test].include?(env)
      InfisicalClient.client.secrets.get(
        secret_name: name,
        project_id: '7f77ea6e-c225-4c3a-844e-039f6467f07f',
        environment: 'dev',
        path: %w[local_dev].include?(env) ? '/sinatra' : '/sinatra/local'
      )['secretValue']
    else
      ENV[name]
    end
  end
end
