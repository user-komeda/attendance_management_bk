# frozen_string_literal: true

# rbs_inline: enabled

require 'infisical-sdk'

module InfisicalClient
  # @rbs @client: untyped

  # @rbs () -> untyped
  def self.client
    @client ||= InfisicalSDK::InfisicalClient.new('https://app.infisical.com').tap do |client|
      p '========================================'
      p 'INFISICAL CLIENT_ID'
      p ENV['CLIENT_ID']
      p 'INFISICAL CLIENT_SECRET'
      p ENV['CLIENT_SECRET']
      client.auth.universal_auth(
        client_id: ENV['CLIENT_ID'] || '',
        client_secret: ENV['CLIENT_SECRET'] || ''
      )
    end
  end
end
