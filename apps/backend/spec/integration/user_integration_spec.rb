# frozen_string_literal: true

require '../spec_helper'

RSpec.describe 'User API integration', type: :request do
  include Rack::Test::Methods

  before do
    @test_repo = InMemoryUserRepo.new
    @test_service = InMemoryUserService.new(@test_repo)
    @resolver = build_resolver

    allow_any_instance_of(ContainerHelper).to receive(:resolve) { |_, key| @resolver.call(key) }
  end

  after do
    @test_repo&.clear
  end

  it 'returns empty list when no users exist' do
    get '/'
    expect(last_response.status).to eq(200)
    body = json(last_response.body)
    expect(body).to eq([])
  end

  it 'returns list of created users' do
    created_users = [
      @test_repo.create(::Domain::Entity::User::UserEntity.build(first_name: 'Taro', last_name: 'Yamada',
                                                                 email: 'taro@example.com')),
      @test_repo.create(::Domain::Entity::User::UserEntity.build(first_name: 'Hanako', last_name: 'Suzuki',
                                                                 email: 'hanako@example.com'))
    ]

    get '/'
    expect(last_response.status).to eq(200)
    body = json(last_response.body)
    expect(body.size).to eq(2)

    created_users.each do |created_user|
      found = body.find { |u| u['id'] == created_user.id.value }
      expect(found).not_to be_nil
      expect(found['first_name']).to eq(created_user.user_name.first_name)
      expect(found['last_name']).to eq(created_user.user_name.last_name)
      expect(found['email']).to eq(created_user.email.value)
    end
  end

  it 'creates user and returns 201 with Location header' do
    post '/', valid_user_params.to_json, json_headers

    expect(last_response.status).to eq(201)
    expect(last_response.headers['Location']).to match(%r{/users/[\w-]+})

    body = json(last_response.body)
    expect(body['first_name']).to eq('Taro')
    expect(body['last_name']).to eq('Yamada')
    expect(body['email']).to eq('taro@example.com')
  end

  it 'returns 409 when email is duplicated' do
    @test_repo.create(::Domain::Entity::User::UserEntity.build(first_name: 'Existing', last_name: 'User',
                                                               email: 'duplicate@example.com'))

    post '/', { first_name: 'New', last_name: 'User', email: 'duplicate@example.com' }.to_json, json_headers

    expect(last_response.status).to eq(409)
    body = json(last_response.body)
    expect(body['message']).to include('already exists')
  end

  it 'returns 400 when email is invalid' do
    post '/', { first_name: 'Test', last_name: 'User', email: 'not-an-email' }.to_json, json_headers

    expect(last_response.status).to eq(400)
    body = json(last_response.body)
    expect(body['message']).to include('email')
  end

  it 'returns 400 when required fields are missing' do
    post '/', {}.to_json, json_headers

    expect(last_response.status).to eq(400)
  end

  it 'returns 400 when first_name is empty' do
    post '/', { first_name: '', last_name: 'Test', email: 'test@example.com' }.to_json, json_headers

    expect(last_response.status).to eq(400)
  end

  it 'returns 200 with user details' do
    user = @test_repo.create(::Domain::Entity::User::UserEntity.build(first_name: 'Test', last_name: 'User',
                                                                      email: 'test@example.com'))

    get "/#{user.id.value}"

    expect(last_response.status).to eq(200)
    body = json(last_response.body)
    expect(body['id']).to eq(user.id.value)
    expect(body['first_name']).to eq('Test')
  end

  it 'returns 404 for nonexistent user' do
    get '/00000000-0000-0000-0000-999999999999'

    expect(last_response.status).to eq(404)
  end

  it 'returns 204 and updates data' do
    user = @test_repo.create(::Domain::Entity::User::UserEntity.build(first_name: 'Old', last_name: 'Name',
                                                                      email: 'old@example.com'))

    patch "/#{user.id.value}", { first_name: 'New', last_name: 'Name', email: 'new@example.com' }.to_json, json_headers

    expect(last_response.status).to eq(204)

    updated = @test_repo.get_by_id(user.id.value)
    expect(updated.user_name.first_name).to eq('New')
    expect(updated.email.value).to eq('new@example.com')
  end

  it 'updates only provided fields (partial update)' do
    user = @test_repo.create(::Domain::Entity::User::UserEntity.build(first_name: 'Original', last_name: 'User',
                                                                      email: 'original@example.com'))

    patch "/#{user.id.value}", { first_name: 'Updated' }.to_json, json_headers

    expect(last_response.status).to eq(204)

    updated = @test_repo.get_by_id(user.id.value)
    expect(updated.user_name.first_name).to eq('Updated')
    expect(updated.user_name.last_name).to eq('User')
    expect(updated.email.value).to eq('original@example.com')
  end

  it 'returns 404 when updating nonexistent user' do
    patch '/00000000-0000-0000-0000-999999999999', { first_name: 'Test' }.to_json, json_headers

    expect(last_response.status).to eq(404)
  end

  it 'returns 400 when email is invalid on update' do
    user = @test_repo.create(::Domain::Entity::User::UserEntity.build(first_name: 'Test', last_name: 'User',
                                                                      email: 'test@example.com'))

    patch "/#{user.id.value}", { email: 'not-an-email' }.to_json, json_headers

    expect(last_response.status).to eq(400)
  end

  it 'validates id format (example validation test)' do
    patch '/bad-uuid', { first_name: 'Test' }.to_json, json_headers

    expect(last_response.status).to eq(400)
  end

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

  it 'allows multiple users to coexist' do
    users_data = [
      { first_name: 'User1', last_name: 'Test1', email: 'user1@example.com' },
      { first_name: 'User2', last_name: 'Test2', email: 'user2@example.com' },
      { first_name: 'User3', last_name: 'Test3', email: 'user3@example.com' }
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
    expect(body.size).to eq(3)

    created_ids.each do |user_id|
      get "/#{user_id}"
      expect(last_response.status).to eq(200)
    end
  end

  # 繝・せ繝育畑縺ｮ繧､繝ｳ繝｡繝｢繝ｪ繝ｪ繝昴ず繝医Μ
  class InMemoryUserRepo
    def initialize
      @users = {}
      @counter = 0
    end

    def get_all
      @users.values
    end

    def get_by_id(id)
      @users[normalize_id(id)]
    end

    def create(entity)
      @counter += 1
      id = ::Domain::ValueObject::IdentityId.build(SecureRandom.uuid)
      entity.id = id
      @users[id.value] = entity
      entity
    end

    def update(entity)
      id_value = entity.id.value
      @users[id_value] = entity if @users.key?(id_value)
      entity
    end

    def find_by_email(email)
      @users.values.find { |u| u.email.value == email }
    end

    def clear
      @users.clear
      @counter = 0
    end

    def count
      @users.size
    end

    private

    def normalize_id(id)
      id.is_a?(String) ? id : id.to_s
    end
  end

  # 繝・せ繝育畑縺ｮ繧､繝ｳ繝｡繝｢繝ｪ繧ｵ繝ｼ繝薙せ
  class InMemoryUserService
    def initialize(repo)
      @repo = repo
    end

    def exist?(email)
      !@repo.find_by_email(email).nil?
    end
  end

  private

  def json(body)
    JSON.parse(body)
  end

  def json_headers
    { 'CONTENT_TYPE' => 'application/json' }
  end

  def valid_user_params
    { first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com' }
  end

  def build_resolver
    lambda do |key|
      case key
      when user_use_case_key(:get_all)
        Application::UseCase::User::GetAllUserUseCase.new
      when user_use_case_key(:get_detail)
        Application::UseCase::User::GetDetailUserUseCase.new
      when user_use_case_key(:create_user)
        Application::UseCase::User::CreateUserUseCase.new
      when user_use_case_key(:update_user)
        Application::UseCase::User::UpdateUserUseCase.new
      when service_key(:user)
        @test_service
      when repository_key(:user)
        @test_repo
      when domain_repository_key(:user)
        @test_repo
      else
        raise AppException::ApiError.new(
          message: "Unknown key: #{key}",
          status_code: :not_found,
          error_code: :not_found
        )
      end
    end
  end

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
