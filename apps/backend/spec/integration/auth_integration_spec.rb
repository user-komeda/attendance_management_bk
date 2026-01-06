# frozen_string_literal: true

require 'securerandom'

require_relative '../spec_helper'

unless Application::UseCase::BaseUseCase.include?(ContainerHelper)
  Application::UseCase::BaseUseCase.include(ContainerHelper)
end

RSpec.describe 'Auth API integration (signup)', type: :request do
  include Rack::Test::Methods

  # These are integration tests against the running Rack app.
  # Keep them independent from container wiring: interact only via HTTP endpoints.

  it 'returns 201 for valid signup' do
    post '/signup', valid_signup_params.to_json, json_headers
    expect(last_response.status).to eq(201)
  end

  it 'returns non-empty id and user_id in response for valid signup' do
    post '/signup', valid_signup_params.to_json, json_headers
    expect(json(last_response.body)).to include('id' => a_string_matching(/\S/), 'user_id' => a_string_matching(/\S/))
  end

  it 'returns 400 when email is invalid' do
    params = valid_signup_params(email: 'not-an-email')

    post '/signup', params.to_json, json_headers

    expect(last_response.status).to eq(400)
  end

  it 'returns 400 when required fields are missing' do
    post '/signup', {}.to_json, json_headers

    expect(last_response.status).to eq(400)
  end

  context 'when email already exists' do
    let(:dup_email) { unique_email('dup') }

    before do
      post '/signup', valid_signup_params(email: dup_email).to_json, json_headers
    end

    it 'returns 409 when signing up with duplicate email' do
      post '/signup', valid_signup_params(email: dup_email).to_json, json_headers
      expect(last_response.status).to eq(409)
    end
  end

  describe 'Auth API integration (signin)' do
    let(:email) { unique_email('signin') }
    let(:password) { 'Password123!' }

    before do
      # Create a user first
      post '/signup', valid_signup_params(email: email, password: password).to_json, json_headers
    end

    it 'returns 200 for valid signin' do
      post '/signin', { email: email, password: password }.to_json, json_headers
      expect(last_response.status).to eq(200)
    end

    it 'returns non-empty id and user_id in response for valid signin' do
      post '/signin', { email: email, password: password }.to_json, json_headers
      expect(json(last_response.body)).to include(
        'id' => (a_string_matching(/\S/) | a_kind_of(Integer)),
        'user_id' => a_string_matching(/\S/)
      )
    end

    it 'returns 401 when password is incorrect' do
      post '/signin', { email: email, password: 'WrongPassword' }.to_json, json_headers
      expect(last_response.status).to eq(401)
    end

    it 'returns 401 when email does not exist' do
      post '/signin', { email: 'nonexistent@example.com', password: password }.to_json, json_headers
      expect(last_response.status).to eq(401)
    end

    it 'returns 400 when required fields are missing' do
      post '/signin', { email: email }.to_json, json_headers
      expect(last_response.status).to eq(400)
    end
  end

  private

  def json(body)
    JSON.parse(body)
  end

  def json_headers
    { 'CONTENT_TYPE' => 'application/json' }
  end

  def valid_signup_params(email: unique_email('taro'), password: 'Password123!')
    {
      first_name: 'Taro',
      last_name: 'Yamada',
      email: email,
      password: password
    }
  end

  def unique_email(base = 'user')
    "#{base}-#{SecureRandom.uuid}@example.com"
  end
end
