# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Repository::User::UserRepository do
  let(:repo) { described_class.new }

  def build_domain_user(id:, first_name:, last_name:, email:)
    Domain::Entity::User::UserEntity.build_with_id(
      id: id,
      first_name: first_name,
      last_name: last_name,
      email: email,
      session_version: 1
    )
  end

  context 'when getting all users' do
    subject(:result) { repo.get_all }

    let(:rom) { instance_double(Infrastructure::Repository::Rom::User::UserRomRepository, rom_get_all: []) }

    before do
      allow(repo).to receive(:resolve).and_return(rom)
    end

    it 'returns an Array' do
      expect(result).to be_a(Array)
    end

    it 'returns empty when rom returns empty' do
      expect(result).to be_empty
    end
  end

  context 'when found by id' do
    subject(:result) { repo.get_by_id(id: '00000000-0000-0000-0000-000000000001') }

    let(:infra_entity) do
      Infrastructure::Entity::User::UserEntity.new(
        id: '00000000-0000-0000-0000-000000000001',
        first_name: 'Hanako',
        last_name: 'Suzuki',
        email: 'hanako@example.com',
        session_version: 1
      )
    end
    let(:rom) { instance_double(Infrastructure::Repository::Rom::User::UserRomRepository) }

    before do
      allow(rom).to receive(:rom_get_by_id)
        .with(id: '00000000-0000-0000-0000-000000000001')
        .and_return(infra_entity)
      allow(repo).to receive(:resolve).and_return(rom)
    end

    it 'returns domain entity' do
      expect(result).to be_a(Domain::Entity::User::UserEntity)
    end

    it 'maps attributes' do
      expect(result.user_name.first_name).to eq('Hanako')
    end

    it 'delegates to rom_get_by_id' do
      result
      expect(rom).to have_received(:rom_get_by_id).with(id: '00000000-0000-0000-0000-000000000001')
    end
  end

  context 'when not found by id' do
    subject(:result) { repo.get_by_id(id: '00000000-0000-0000-0000-000000000001') }

    let(:rom) { instance_double(Infrastructure::Repository::Rom::User::UserRomRepository) }

    before do
      allow(rom).to receive(:rom_get_by_id)
        .with(id: '00000000-0000-0000-0000-000000000001')
        .and_return(nil)
      allow(repo).to receive(:resolve).and_return(rom)
    end

    it 'returns nil' do
      expect(result).to be_nil
    end

    it 'delegates to rom_get_by_id' do
      result
      expect(rom).to have_received(:rom_get_by_id).with(id: '00000000-0000-0000-0000-000000000001')
    end
  end

  context 'when creating a user' do
    subject(:result) { repo.create(user_entity: domain) }

    let(:domain) do
      build_domain_user(id: '00000000-0000-0000-0000-000000000001', first_name: 'Ken', last_name: 'Tanaka',
                        email: 'ken@example.com')
    end

    let(:created_struct) do
      Struct.new(:id, :first_name, :last_name, :email, :session_version).new(
        '00000000-0000-0000-0000-000000000001',
        'Ken',
        'Tanaka',
        'ken@example.com',
        1
      )
    end

    let(:rom) { instance_double(Infrastructure::Repository::Rom::User::UserRomRepository) }

    before do
      allow(rom).to receive(:rom_create)
        .with(instance_of(Infrastructure::Entity::User::UserEntity))
        .and_return(created_struct)
      allow(repo).to receive(:resolve).and_return(rom)
    end

    it 'returns domain entity' do
      expect(result).to be_a(Domain::Entity::User::UserEntity)
    end

    it 'sets first_name' do
      expect(result.user_name.first_name).to eq('Ken')
    end

    it 'sets email' do
      expect(result.email.value).to eq('ken@example.com')
    end

    it 'delegates to rom_create' do
      result
      expect(rom).to have_received(:rom_create).with(instance_of(Infrastructure::Entity::User::UserEntity))
    end
  end

  context 'when updating a user' do
    subject(:result) { repo.update(user_entity: domain) }

    let(:domain) do
      build_domain_user(id: '00000000-0000-0000-0000-000000000001', first_name: 'New', last_name: 'Name',
                        email: 'new@example.com')
    end
    let(:updated_struct) do
      Struct.new(:id, :first_name, :last_name, :email, :session_version).new(
        '00000000-0000-0000-0000-000000000001',
        'New',
        'Name',
        'new@example.com',
        1
      )
    end
    let(:rom) { instance_double(Infrastructure::Repository::Rom::User::UserRomRepository) }

    before do
      allow(rom).to receive(:rom_update)
        .with(user_entity: instance_of(Infrastructure::Entity::User::UserEntity))
        .and_return(updated_struct)
      allow(repo).to receive(:resolve).and_return(rom)
    end

    it 'returns domain entity' do
      expect(result).to be_a(Domain::Entity::User::UserEntity)
    end

    it 'updates first_name' do
      expect(result.user_name.first_name).to eq('New')
    end

    it 'updates email' do
      expect(result.email.value).to eq('new@example.com')
    end

    it 'delegates to rom_update' do
      result
      expect(rom).to have_received(:rom_update).with(user_entity: instance_of(Infrastructure::Entity::User::UserEntity))
    end
  end

  context 'when finding by email' do
    subject(:find_result) { repo.find_by_email(email: 'x@example.com') }

    let(:rom) { instance_double(Infrastructure::Repository::Rom::User::UserRomRepository) }

    before do
      allow(rom).to receive(:find_by_email).with(email: 'x@example.com').and_return(nil)
      allow(repo).to receive(:resolve).and_return(rom)
    end

    it 'returns nil when not found' do
      expect(find_result).to be_nil
    end

    it 'delegates to rom' do
      find_result
      expect(rom).to have_received(:find_by_email).with(email: 'x@example.com')
    end

    context 'when found' do
      let(:found_email) { 'found@example.com' }
      let(:infra_entity) do
        Infrastructure::Entity::User::UserEntity.new(
          id: '00000000-0000-0000-0000-000000000001',
          first_name: 'F',
          last_name: 'L',
          email: found_email,
          session_version: 1
        )
      end

      before do
        allow(rom).to receive(:find_by_email).with(email: found_email).and_return(infra_entity)
      end

      it 'returns domain entity' do
        expect(repo.find_by_email(email: found_email)).to be_a(Domain::Entity::User::UserEntity)
      end

      it 'maps the id correctly' do
        expect(repo.find_by_email(email: found_email).id.value).to eq('00000000-0000-0000-0000-000000000001')
      end

      it 'maps the email correctly' do
        expect(repo.find_by_email(email: found_email).email.value).to eq(found_email)
      end
    end
  end

  describe '#create_with_auth_user' do
    subject(:result) { repo.create_with_auth_user(user_with_auth_user: input) }

    let(:user_id) { SecureRandom.uuid }
    let(:auth_user_id) { SecureRandom.uuid }
    let(:email) { 'test@example.com' }
    let(:input) do
      {
        user_name: Domain::ValueObject::User::UserName.build('Taro', 'Yamada'),
        email: Domain::ValueObject::User::UserEmail.build(email),
        auth_user: {
          email: Domain::ValueObject::User::UserEmail.build(email),
          password_digest: Domain::ValueObject::AuthUser::PasswordDigest.build('Password123!')
        }
      }
    end

    let(:infra_entity) do
      auth_user_struct = double(
        'auth_user_struct',
        id: auth_user_id,
        user_id: user_id,
        email: email,
        password_digest: 'Password123!',
        provider: 'email',
        is_active: true,
        last_login_at: nil
      )
      double(
        'user_struct',
        id: user_id,
        first_name: 'Taro',
        last_name: 'Yamada',
        email: email,
        session_version: 1,
        auth_user: auth_user_struct
      )
    end

    let(:rom) { instance_double(Infrastructure::Repository::Rom::User::UserRomRepository) }

    before do
      allow(rom).to receive(:create_with_auth_user).and_return(infra_entity)
      allow(repo).to receive(:resolve).and_return(rom)
    end

    it 'returns a hash with user_entity and auth_user_entity' do
      expect(result).to include(:user_entity, :auth_user_entity)
    end

    it 'contains domain user entity' do
      expect(result[:user_entity]).to be_a(Domain::Entity::User::UserEntity)
    end

    it 'contains domain auth user entity' do
      expect(result[:auth_user_entity]).to be_a(Domain::Entity::Auth::AuthUserEntity)
    end
  end

  describe 'Infrastructure::Entity::User::UserEntity' do
    let(:user_id) { SecureRandom.uuid }
    let(:email) { 'test@example.com' }
    let(:domain_user) do
      Domain::Entity::User::UserEntity.build_with_id(
        id: user_id,
        first_name: 'Taro',
        last_name: 'Yamada',
        email: email,
        session_version: 1
      )
    end

    it 'converts to domain' do
      infra = Infrastructure::Entity::User::UserEntity.new(
        id: user_id, first_name: 'Taro', last_name: 'Yamada', email: email, session_version: 1
      )
      expect(infra.to_domain).to be_a(Domain::Entity::User::UserEntity)
    end

    it 'converts struct to domain' do
      struct = double('struct', id: user_id, first_name: 'Taro', last_name: 'Yamada', email: email, session_version: 1)
      result = Infrastructure::Entity::User::UserEntity.struct_to_domain(struct: struct)
      expect(result).to be_a(Domain::Entity::User::UserEntity)
    end

    it 'builds from domain entity' do
      result = Infrastructure::Entity::User::UserEntity.build_from_domain_entity(user_entity: domain_user)
      expect(result).to be_a(Infrastructure::Entity::User::UserEntity)
      expect(result.id).to eq(user_id)
    end

    it 'generates uuid when domain id is empty' do
      domain_no_id = double('domain_user',
                            id: nil,
                            user_name: double('name', first_name: 'A', last_name: 'B'),
                            email: double('email', value: 'a@b.c'))
      result = Infrastructure::Entity::User::UserEntity.build_from_domain_entity(user_entity: domain_no_id)
      expect(result.id).not_to be_empty
    end
  end
end
