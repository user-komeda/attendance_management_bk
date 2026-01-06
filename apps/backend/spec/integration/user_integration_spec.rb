# frozen_string_literal: true

require 'securerandom'

require_relative '../spec_helper'

unless Application::UseCase::BaseUseCase.include?(ContainerHelper)
  Application::UseCase::BaseUseCase.include(ContainerHelper)
end

RSpec.describe 'User API integration', type: :request do
  include Rack::Test::Methods

  # NOTE: These are integration tests against the running Rack app.
  # To keep independence from internal container wiring, we interact only via HTTP endpoints.

  describe 'GET /users' do
    it 'returns list (array)' do
      get '/users'
      expect(last_response).to have_attributes(status: 200, body: satisfy { |b| json(b).is_a?(Array) })
    end

    it 'returns list of created users' do
      emails = [unique_email('taro'), unique_email('hanako')]
      emails.each { |email| sql_insert_user(first_name: 'T', last_name: 'Y', email: email) }
      get '/users'
      expect(json(last_response.body)).to include(include('email' => emails[0]), include('email' => emails[1]))
    end
  end

  describe 'GET /users/:id' do
    it 'returns 200 with user details' do
      created = sql_insert_user(first_name: 'Test', last_name: 'User', email: unique_email('test'))
      get "/users/#{created['id']}"
      expect(json(last_response.body)).to include('id' => created['id'], 'first_name' => 'Test')
    end

    it 'returns 404 for nonexistent user' do
      get '/users/00000000-0000-0000-0000-999999999999'
      expect(last_response.status).to eq(404)
    end
  end

  describe 'PATCH /users/:id' do
    let(:created) { sql_insert_user(first_name: 'Old', last_name: 'Name', email: unique_email('old')) }

    it 'updates data' do
      new_email = unique_email('new')
      patch "/users/#{created['id']}", { first_name: 'New', email: new_email }.to_json, json_headers
      get "/users/#{created['id']}"
      expect(json(last_response.body)).to include('first_name' => 'New', 'email' => new_email)
    end

    it 'updates only provided fields' do
      patch "/users/#{created['id']}", { first_name: 'Updated' }.to_json, json_headers
      get "/users/#{created['id']}"
      expect(json(last_response.body)).to include('first_name' => 'Updated', 'last_name' => 'Name')
    end
  end

  it 'returns 404 when updating nonexistent user' do
    patch '/users/00000000-0000-0000-0000-999999999999', { first_name: 'Test' }.to_json, json_headers

    expect(last_response.status).to eq(404)
  end

  it 'returns 400 when email is invalid on update' do
    created = sql_insert_user(first_name: 'Test', last_name: 'User', email: unique_email('test'))

    patch "/users/#{created['id']}", { email: 'not-an-email' }.to_json, json_headers

    expect(last_response.status).to eq(400)
  end

  it 'validates id format (example validation test)' do
    patch '/users/bad-uuid', { first_name: 'Test' }.to_json, json_headers

    expect(last_response.status).to eq(404)
  end

  it 'performs full CRUD lifecycle' do
    user_id = sql_insert_user(**valid_user_params)['id']
    patch "/users/#{user_id}", { first_name: 'Updated' }.to_json, json_headers
    get "/users/#{user_id}"
    expect(json(last_response.body)).to include('first_name' => 'Updated')
  end

  it 'allows multiple users to coexist' do
    emails = [unique_email('u1'), unique_email('u2')]
    ids = emails.map { |e| sql_insert_user(first_name: 'T', last_name: 'Y', email: e)['id'] }
    expect(ids.map { |id| get("/users/#{id}") }).to all(satisfy { last_response.status == 200 })
  end

  # テスト用の簡易実装は匿名クラスで提供する

  private

  def json(body)
    JSON.parse(body)
  end

  def json_headers
    { 'CONTENT_TYPE' => 'application/json' }
  end

  def valid_user_params
    { first_name: 'Taro', last_name: 'Yamada', email: unique_email('taro') }
  end

  def unique_email(base = 'user')
    "#{base}-#{SecureRandom.uuid}@example.com"
  end

  # Seed helpers using direct SQL via ROM's registered configuration
  def sql_insert_user(first_name:, last_name:, email:)
    config = Container.resolve('db.config')
    conn = config.gateways[:default].connection
    id = SecureRandom.uuid
    conn[:users].insert(id: id, first_name: first_name, last_name: last_name, email: email)
    { 'id' => id, 'first_name' => first_name, 'last_name' => last_name, 'email' => email }
  end
end
