# frozen_string_literal: true

require 'securerandom'
require_relative '../spec_helper'

RSpec.describe 'WorkSpace API integration', type: :request do
  include Rack::Test::Methods

  let(:email) { "user-#{SecureRandom.uuid}@example.com" }
  let(:password) { 'Password123!' }
  let!(:auth_headers) do
    post '/signup', {
      first_name: 'Taro',
      last_name: 'Yamada',
      email: email,
      password: password
    }.to_json, { 'CONTENT_TYPE' => 'application/json' }

    post '/signin', { email: email, password: password }.to_json, { 'CONTENT_TYPE' => 'application/json' }
    token = JSON.parse(last_response.body)['id']
    { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => "Bearer #{token}" }
  end

  describe 'POST /work_spaces' do
    let(:params) { { name: 'Test WorkSpace', slug: "slug-#{SecureRandom.uuid}" } }

    it 'creates a workspace and returns 201' do
      post '/work_spaces', params.to_json, auth_headers
      expect(last_response.status).to eq(201)

      body = JSON.parse(last_response.body)
      expect(body['work_spaces']['name']).to eq('Test WorkSpace')
      expect(body['member_ships']['role']).to eq('owner')
    end

    it 'returns 400 for invalid params' do
      post '/work_spaces', { name: '' }.to_json, auth_headers
      expect(last_response.status).to eq(400)
    end
  end

  describe 'GET /work_spaces' do
    before do
      post '/work_spaces', { name: 'WS1', slug: "ws1-#{SecureRandom.uuid}" }.to_json, auth_headers
    end

    it 'returns a list of workspaces' do
      get '/work_spaces', nil, auth_headers
      expect(last_response.status).to eq(200)

      body = JSON.parse(last_response.body)
      expect(body).to be_an(Array)
      expect(body.size).to be >= 1
    end
  end

  describe 'GET /work_spaces/:id' do
    let(:workspace_id) do
      post '/work_spaces', { name: 'WS Detail', slug: "ws-detail-#{SecureRandom.uuid}" }.to_json, auth_headers
      JSON.parse(last_response.body)['id']
    end

    it 'returns workspace details' do
      get "/work_spaces/#{workspace_id}", nil, auth_headers
      expect(last_response.status).to eq(200)

      body = JSON.parse(last_response.body)
      expect(body['id']).to eq(workspace_id)
    end

    it 'returns 404 for non-existent workspace' do
      get "/work_spaces/#{SecureRandom.uuid}", nil, auth_headers
      expect(last_response.status).to eq(404)
    end
  end

  describe 'PATCH /work_spaces/:id' do
    let(:workspace_id) do
      post '/work_spaces', { name: 'Old Name', slug: "old-slug-#{SecureRandom.uuid}" }.to_json, auth_headers
      JSON.parse(last_response.body)['id']
    end

    it 'updates the workspace' do
      patch "/work_spaces/#{workspace_id}", { name: 'New Name' }.to_json, auth_headers
      expect(last_response.status).to eq(204)
    end
  end

  describe 'DELETE /work_spaces/:id' do
    let(:workspace_id) do
      post '/work_spaces', { name: 'To Be Deleted', slug: "delete-#{SecureRandom.uuid}" }.to_json, auth_headers
      JSON.parse(last_response.body)['id']
    end

    it 'deletes the workspace' do
      delete "/work_spaces/#{workspace_id}", nil, auth_headers
      expect(last_response.status).to eq(204)

      get "/work_spaces/#{workspace_id}", nil, auth_headers
      expect(last_response.status).to eq(404)
    end
  end
end
