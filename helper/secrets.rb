# frozen_string_literal: true

module Secrets
  def self.fetch(name, project_id:, environment:)
    InfisicalClient.client.secrets.get(
      secret_name: name,
      project_id: project_id,
      environment: environment,
      path: '/sinatra'
    )['secretValue']
  end
end
