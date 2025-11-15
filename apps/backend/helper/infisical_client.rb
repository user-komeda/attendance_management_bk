# frozen_string_literal: true

# rbs_inline: enabled

require 'infisical-sdk'

module InfisicalClient
  # @rbs @client: untyped

  # @rbs () -> untyped
  def self.client
    @client ||= InfisicalSDK::InfisicalClient.new('https://app.infisical.com').tap do |client|
      client.auth.universal_auth(
        client_id: ENV['CLIENT_ID'] || '',
        client_secret: ENV['CLIENT_SECRET'] || ''
      )
    end
  end
end
