# frozen_string_literal: true

# rbs_inline: enabled

require 'infisical-sdk'

module InfisicalClient
  # @rbs @client: untyped

  # @rbs () -> untyped
  def self.client
    @client ||= InfisicalSDK::InfisicalClient.new('https://app.infisical.com').tap do |client|
      p '========================================'
      p ENV['CLIENT_ID']
      p ENV['CLIENT_SECRET']
      client.auth.universal_auth(
        client_id: ENV['CLIENT_ID'] || 'bcb5e70a-bce3-47b8-b176-15475e005f39',
        client_secret: ENV['CLIENT_SECRET'] || 'b7d54d66dde7db57c76a59c2e926d168efce7a569446546a3fd5c049689eb77a'
      )
    end
  end
end
