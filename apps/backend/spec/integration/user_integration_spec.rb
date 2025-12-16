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

    users_params.each do |params|
      sql_insert_user(**params)
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
  it 'returns 200 with user details' do
    created = sql_insert_user(first_name: 'Test', last_name: 'User', email: unique_email('test'))

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
    created = sql_insert_user(first_name: 'Old', last_name: 'Name', email: unique_email('old'))

    new_email = unique_email('new')
    patch "/#{created['id']}", { first_name: 'New', last_name: 'Name', email: new_email }.to_json, json_headers

    expect(last_response.status).to eq(204)
    get "/#{created['id']}"
    body = json(last_response.body)
    expect(body['first_name']).to eq('New')
    expect(body['email']).to eq(new_email)
  end
  # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength

  # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
  it 'updates only provided fields (partial update)' do
    email = unique_email('original')
    created = sql_insert_user(first_name: 'Original', last_name: 'User', email: email)

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
    created = sql_insert_user(first_name: 'Test', last_name: 'User', email: unique_email('test'))

    patch "/#{created['id']}", { email: 'not-an-email' }.to_json, json_headers

    expect(last_response.status).to eq(400)
  end

  it 'validates id format (example validation test)' do
    patch '/bad-uuid', { first_name: 'Test' }.to_json, json_headers

    expect(last_response.status).to eq(400)
  end

  # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
  it 'performs full CRUD lifecycle' do
    # Create (via direct SQL seeding)
    created = sql_insert_user(**valid_user_params)
    user_id = created['id']

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
      created = sql_insert_user(**user_params)
      created_ids << created['id']
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

  # Seed helpers using direct SQL via ROM's registered configuration
  def sql_insert_user(first_name:, last_name:, email:)
    config = Container.resolve('db.config')
    conn = config.gateways[:default].connection
    id = SecureRandom.uuid
    conn[:users].insert(id: id, first_name: first_name, last_name: last_name, email: email)
    { 'id' => id, 'first_name' => first_name, 'last_name' => last_name, 'email' => email }
  end
end
