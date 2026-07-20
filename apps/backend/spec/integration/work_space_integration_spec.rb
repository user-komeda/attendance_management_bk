# frozen_string_literal: true

require 'securerandom'
require_relative '../spec_helper'

RSpec.describe 'WorkSpace API integration', type: :request do
  include Rack::Test::Methods

  let(:email) { "user-#{SecureRandom.uuid}@example.com" }
  let(:password) { 'Password123!' }
  let!(:auth_headers) do
    # Create the fixed user for development/testing context if it doesn't exist
    fixed_user_id = '04e8496c-6b8c-4f4f-9746-2d96a10f13ec'
    rom = Container.resolve('container')
    unless rom.relations[:users].by_pk(fixed_user_id).one
      rom.relations[:users].command(:create).call(
        id: fixed_user_id,
        first_name: 'Fixed',
        last_name: 'User',
        email: 'fixed-user@example.com'
      )
    end

    post '/signup', {
      first_name: 'Taro',
      last_name: 'Yamada',
      email: email,
      password: password
    }.to_json, { 'CONTENT_TYPE' => 'application/json' }

    post '/signin', { email: email, password: password }.to_json, { 'CONTENT_TYPE' => 'application/json' }
    token = JSON.parse(last_response.body)['user_id']
    { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => "Bearer #{token}" }
  end

  describe 'POST /work_spaces' do
    let(:params) { { name: 'Test WorkSpace', slug: "slug-#{SecureRandom.uuid}" } }

    it 'creates a workspace' do
      post '/work_spaces', params.to_json, auth_headers
      expect_created_workspace
    end

    def expect_created_workspace
      aggregate_failures do
        expect(last_response.status).to eq(201)
        expect(workspace_name_from_body).to eq('Test WorkSpace')
        expect(membership_role_from_body).to eq('owner')
      end
    end

    def workspace_name_from_body
      JSON.parse(last_response.body).dig('work_spaces', 'name')
    end

    def membership_role_from_body
      JSON.parse(last_response.body).dig('member_ships', 0, 'role')
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

    it 'returns a list of contentApi' do
      get '/work_spaces', nil, auth_headers
      expect_workspace_list
    end

    def expect_workspace_list
      aggregate_failures do
        expect(last_response.status).to eq(200)
        expect_valid_workspace_list_body(JSON.parse(last_response.body))
      end
    end

    def expect_valid_workspace_list_body(body)
      expect(body).to be_an(Hash)
      expect(body['data']).to be_an(Array)
      expect(body['data'].size).to be >= 1
    end
  end

  describe 'GET /work_spaces/:id' do
    let(:workspace_slug) { "ws-detail-#{SecureRandom.hex(4)}" }
    let!(:workspace_id) do
      post '/work_spaces', { name: 'WS Detail', slug: workspace_slug }.to_json, auth_headers
      JSON.parse(last_response.body)['id']
    end

    it 'returns workspace details' do
      get "/work_spaces/#{workspace_slug}", nil, auth_headers
      aggregate_failures do
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)['id']).to eq(workspace_id)
      end
    end

    it 'returns 404 for non-existent workspace' do
      get '/work_spaces/nonexistent-slug', nil, auth_headers
      expect(last_response.status).to eq(404)
    end
  end

  describe 'PATCH /work_spaces/:id' do
    let(:workspace_slug) { "old-slug-#{SecureRandom.hex(4)}" }

    before do
      post '/work_spaces', { name: 'Old Name', slug: workspace_slug }.to_json, auth_headers
    end

    it 'updates the workspace' do
      patch "/work_spaces/#{workspace_slug}", { name: 'New Name' }.to_json, auth_headers
      expect(last_response.status).to eq(204)
    end
  end

  describe 'DELETE /work_spaces/:id' do
    let(:workspace_slug) { "delete-#{SecureRandom.hex(4)}" }

    before do
      post '/work_spaces', { name: 'To Be Deleted', slug: workspace_slug }.to_json, auth_headers
    end

    it 'deletes the workspace' do
      delete "/work_spaces/#{workspace_slug}", nil, auth_headers
      expect_deleted_workspace(workspace_slug)
    end

    def expect_deleted_workspace(slug)
      aggregate_failures do
        expect(last_response.status).to eq(204)
        get "/work_spaces/#{slug}", nil, auth_headers
        expect(last_response.status).to eq(404)
      end
    end
  end
end
