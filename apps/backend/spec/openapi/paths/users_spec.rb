# frozen_string_literal: true

require 'securerandom'

require_relative '../spec_helper'

RSpec.describe 'Users', type: :openapi do
  describe 'GET /users' do
    let(:conn) { Container.resolve('db.config').gateways[:default].connection }

    before do
      conn[:users].insert(
        id: SecureRandom.uuid,
        first_name: 'Taro',
        last_name: 'Yamada',
        email: "users-#{SecureRandom.uuid}@example.com"
      )
    end

    it 'returns 200' do
      aggregate_failures do
        expect(optional_query_parameters('users.yaml', :get)).to be_empty
        get '/users'
        expect(last_response.status).to eq(200)
      end
    end
  end
end
