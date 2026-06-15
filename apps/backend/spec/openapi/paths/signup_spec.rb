# frozen_string_literal: true

require 'securerandom'

require_relative '../spec_helper'

RSpec.describe 'Signup', type: :openapi do
  describe 'POST /signup' do
    let(:request_body) do
      {
        first_name: 'Taro',
        last_name: 'Yamada',
        email: "signup-#{SecureRandom.uuid}@example.com",
        password: 'Password123!'
      }
    end

    it 'returns 201 with valid request' do
      post '/signup', request_body.to_json, json_headers
      expect(last_response.status).to eq(201)
    end

    it 'matches OpenAPI contract with invalid request' do
      request_body = {}

      post '/signup', request_body.to_json, json_headers

      expect(last_response.status).to eq(400)
    end
  end
end
