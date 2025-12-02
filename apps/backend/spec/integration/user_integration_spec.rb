# frozen_string_literal: true

require 'securerandom'

require_relative '../spec_helper'

RSpec.describe 'User API integration', type: :request do
  include Rack::Test::Methods

  # NOTE: These are integration tests against the running Rack app.
  # To keep independence from internal container wiring, we interact only via HTTP endpoints.

  # rubocop:disable RSpec/MultipleExpectations
  it 'returns list (array) for GET /' do
    get '/'
    expect(last_response.status).to eq(200)
    body = json(last_response.body)
    expect(body).to be_a(Array)
  end
  # rubocop:enable RSpec/MultipleExpectations

  # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
  it 'returns list of created users' do
    users_params = [
      { first_name: 'Taro', last_name: 'Yamada', email: unique_email('taro') },
      { first_name: 'Hanako', last_name: 'Suzuki', email: unique_email('hanako') }
    ]

    users_params.map do |params|
      post '/', params.to_json, json_headers
      expect(last_response.status).to eq(201)
      json(last_response.body)
    end

    get '/'
    expect(last_response.status).to eq(200)
    body = json(last_response.body)

    users_params.each do |params|
      found = body.find { |u| u['email'] == params[:email] }
      expect(found).not_to be_nil
      expect(found['first_name']).to eq(params[:first_name])
      expect(found['last_name']).to eq(params[:last_name])
    end
  end
  # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength

  # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
  it 'creates user and returns 201 with Location header' do
    params = valid_user_params
    post '/', params.to_json, json_headers

    expect(last_response.status).to eq(201)
    expect(last_response.headers['Location']).to match(%r{/users/[\w-]+})

    body = json(last_response.body)
    expect(body['first_name']).to eq('Taro')
    expect(body['last_name']).to eq('Yamada')
    expect(body['email']).to eq(params[:email])
  end
  # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength

  # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
  it 'returns 409 when email is duplicated' do
    dup_email = unique_email('duplicate')
    post '/', { first_name: 'Existing', last_name: 'User', email: dup_email }.to_json, json_headers
    expect(last_response.status).to eq(201)

    post '/', { first_name: 'New', last_name: 'User', email: dup_email }.to_json, json_headers

    expect(last_response.status).to eq(409)
    body = json(last_response.body)
    expect(body['message']).to include('already exists')
  end
  # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength

  # rubocop:disable RSpec/MultipleExpectations
  it 'returns 400 when email is invalid' do
    post '/', { first_name: 'Test', last_name: 'User', email: 'not-an-email' }.to_json, json_headers

    expect(last_response.status).to eq(400)
    body = json(last_response.body)
    expect(body['message']).to include('email')
  end
  # rubocop:enable RSpec/MultipleExpectations

  it 'returns 400 when required fields are missing' do
    post '/', {}.to_json, json_headers

    expect(last_response.status).to eq(400)
  end

  it 'returns 400 when first_name is empty' do
    post '/', { first_name: '', last_name: 'Test', email: 'test@example.com' }.to_json, json_headers

    expect(last_response.status).to eq(400)
  end

  # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
  it 'returns 200 with user details' do
    post '/', { first_name: 'Test', last_name: 'User', email: unique_email('test') }.to_json, json_headers
    expect(last_response.status).to eq(201)
    created = json(last_response.body)

    get "/#{created['id']}"

    expect(last_response.status).to eq(200)
    body = json(last_response.body)
    expect(body['id']).to eq(created['id'])
    expect(body['first_name']).to eq('Test')
  end
  # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength

  it 'returns 404 for nonexistent user' do
    get '/00000000-0000-0000-0000-999999999999'

    expect(last_response.status).to eq(404)
  end

  # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
  it 'returns 204 and updates data' do
    post '/', { first_name: 'Old', last_name: 'Name', email: unique_email('old') }.to_json, json_headers
    expect(last_response.status).to eq(201)
    created = json(last_response.body)

    patch "/#{created['id']}", { first_name: 'New', last_name: 'Name', email: 'new@example.com' }.to_json, json_headers

    expect(last_response.status).to eq(204)
    get "/#{created['id']}"
    body = json(last_response.body)
    expect(body['first_name']).to eq('New')
    expect(body['email']).to eq('new@example.com')
  end
  # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength

  # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
  it 'updates only provided fields (partial update)' do
    email = unique_email('original')
    post '/', { first_name: 'Original', last_name: 'User', email: email }.to_json, json_headers
    expect(last_response.status).to eq(201)
    created = json(last_response.body)

    patch "/#{created['id']}", { first_name: 'Updated' }.to_json, json_headers

    expect(last_response.status).to eq(204)
    get "/#{created['id']}"
    body = json(last_response.body)
    expect(body['first_name']).to eq('Updated')
    expect(body['last_name']).to eq('User')
    expect(body['email']).to eq(email)
  end
  # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength

  it 'returns 404 when updating nonexistent user' do
    patch '/00000000-0000-0000-0000-999999999999', { first_name: 'Test' }.to_json, json_headers

    expect(last_response.status).to eq(404)
  end

  it 'returns 400 when email is invalid on update' do
    post '/', { first_name: 'Test', last_name: 'User', email: unique_email('test') }.to_json, json_headers
    created = json(last_response.body)

    patch "/#{created['id']}", { email: 'not-an-email' }.to_json, json_headers

    expect(last_response.status).to eq(400)
  end

  it 'validates id format (example validation test)' do
    patch '/bad-uuid', { first_name: 'Test' }.to_json, json_headers

    expect(last_response.status).to eq(400)
  end

  # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
  it 'performs full CRUD lifecycle' do
    # Create
    post '/', valid_user_params.to_json, json_headers
    expect(last_response.status).to eq(201)
    created_body = json(last_response.body)
    user_id = created_body['id']

    # Read
    get "/#{user_id}"
    expect(last_response.status).to eq(200)

    # Update
    patch "/#{user_id}", { first_name: 'Updated' }.to_json, json_headers
    expect(last_response.status).to eq(204)

    # Verify update
    get "/#{user_id}"
    body = json(last_response.body)
    expect(body['first_name']).to eq('Updated')
  end
  # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength

  # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
  it 'allows multiple users to coexist' do
    users_data = [
      { first_name: 'User1', last_name: 'Test1', email: unique_email('user1') },
      { first_name: 'User2', last_name: 'Test2', email: unique_email('user2') },
      { first_name: 'User3', last_name: 'Test3', email: unique_email('user3') }
    ]

    created_ids = []
    users_data.each do |user_params|
      post '/', user_params.to_json, json_headers
      expect(last_response.status).to eq(201)
      body = json(last_response.body)
      created_ids << body['id']
    end

    get '/'
    body = json(last_response.body)
    # Ensure at least the created users exist, without assuming global count
    users_data.each do |params|
      expect(body.any? { |u| u['email'] == params[:email] }).to be true
    end

    created_ids.each do |user_id|
      get "/#{user_id}"
      expect(last_response.status).to eq(200)
    end
  end
  # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength

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

  def build_resolver; end

  def resolver_mapping; end

  def user_use_case_key(action)
    Constant::ContainerKey::ApplicationKey::USER_USE_CASE[action].key
  end

  def service_key(name)
    Constant::ContainerKey::ServiceKey::SERVICE[name].key
  end

  def repository_key(name)
    Constant::ContainerKey::RepositoryKey::REPOSITORY[name].key
  end

  def domain_repository_key(name)
    Constant::ContainerKey::DomainRepositoryKey::DOMAIN_REPOSITORY[name].key
  end
end
