# frozen_string_literal: true

require 'infisical-sdk'

module InfisicalClient
  def self.client
    @client ||= InfisicalSDK::InfisicalClient.new('https://app.infisical.com').tap do |client|
      client.auth.universal_auth(
        client_id: '',
        client_secret: ''
      )
    end
  end
end
