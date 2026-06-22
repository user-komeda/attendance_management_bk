# frozen_string_literal: true

require 'securerandom'

require_relative '../spec_helper'

RSpec.describe 'Signin', type: :openapi do
  describe 'POST /signin' do
    let(:email) { "signin-#{SecureRandom.uuid}@example.com" }
    let(:password) { 'Password123!' }
    let(:signup_body) do
      {
        first_name: 'Taro',
        last_name: 'Yamada',
        email: email,
        password: password
      }
    end

    before do
      post '/signup', signup_body.to_json, json_headers
    end

    it 'returns 200 with valid request' do
      request_body = { email: email, password: password }
      post '/signin', request_body.to_json, json_headers
      expect(last_response.status).to eq(200)
    end

    it 'returns 400 with missing password' do
      request_body = { email: email }
      post '/signin', request_body.to_json, json_headers
      expect(last_response.status).to eq(400)
    end

    it 'returns 401 with wrong password' do
      request_body = { email: email, password: 'WrongPassword!' }
      post '/signin', request_body.to_json, json_headers
      expect(last_response.status).to eq(401)
    end
  end
end
