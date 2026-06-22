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

    it 'returns 400 with invalid email' do
      invalid_body = request_body.merge(email: 'not-an-email')
      post '/signup', invalid_body.to_json, json_headers
      expect(last_response.status).to eq(400)
    end

    it 'returns 409 when email already exists' do
      dup_email = "dup-#{SecureRandom.uuid}@example.com"
      dup_body = request_body.merge(email: dup_email)
      post '/signup', dup_body.to_json, json_headers
      post '/signup', dup_body.to_json, json_headers
      expect(last_response.status).to eq(409)
    end
  end
end
