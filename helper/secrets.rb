# frozen_string_literal: true

module Secrets
  def self.get(name)
    p(ENV['RACK_ENV'])
    if ENV['RACK_ENV'] == 'local'
      InfisicalClient.client.secrets.get(
        secret_name: name,
        project_id: '7f77ea6e-c225-4c3a-844e-039f6467f07f',
        environment: 'dev',
        path: '/sinatra'
      )['secretValue']
    else
      ENV[name]
    end
  end
end
