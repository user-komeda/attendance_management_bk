# frozen_string_literal: true

require 'securerandom'

require_relative '../spec_helper'

RSpec.describe 'UsersId', type: :openapi do
  let(:conn) { Container.resolve('db.config').gateways[:default].connection }

  describe 'GET /users/:id' do
    let(:user_id) { SecureRandom.uuid }

    before do
      conn[:users].insert(
        id: user_id,
        first_name: 'Taro',
        last_name: 'Yamada',
        email: "user-#{SecureRandom.uuid}@example.com"
      )
    end

    it 'returns 200' do
      get "/users/#{user_id}"
      expect(last_response.status).to eq(200)
    end
  end

  describe 'PATCH /users/:id' do
    let(:user_id) { SecureRandom.uuid }
    let(:update_properties) do
      {
        first_name: 'New',
        last_name: 'Name',
        email: "new-#{SecureRandom.uuid}@example.com"
      }
    end

    before do
      conn[:users].insert(
        id: user_id,
        first_name: 'Old',
        last_name: 'User',
        email: "old-#{SecureRandom.uuid}@example.com"
      )
    end

    it 'updates user with all optional properties' do
      patch "/users/#{user_id}", update_properties.to_json, json_headers
      expect(last_response.status).to eq(204)
    end

    it 'touches update properties for coverage' do
      aggregate_failures do
        expect(update_properties.keys.map(&:to_s)).to match_array(optional_properties('UpdateUserRequest'))
        expect(touch_openapi_schema_properties('UpdateUserRequest', update_properties)).to be_a(Set)
      end
    end

    it 'returns 400 with invalid email' do
      request_body = { email: 'invalid-email' }
      patch "/users/#{user_id}", request_body.to_json, json_headers

      expect(last_response.status).to eq(400)
      touch_openapi_schema_properties('Error', json(last_response.body))
    end
  end

  # describe 'DELETE /users/:id' do
  #   it 'matches OpenAPI contract' do
  #     config = Container.resolve('db.config')
  #     conn = config.gateways[:default].connection
  #
  #     user_id = SecureRandom.uuid
  #
  #     conn[:users].insert(
  #       id: user_id,
  #       first_name: 'Delete',
  #       last_name: 'User',
  #       email: "delete-#{SecureRandom.uuid}@example.com"
  #     )
  #
  #     delete "/users/#{user_id}"
  #
  #     expect(last_response.status).to eq(204)
  #   end
  # end
end
