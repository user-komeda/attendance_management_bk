# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Repository::User::UserRepository do
  let(:repo) { described_class.new }

  def build_domain_user(id:, first_name:, last_name:, email:)
    Domain::Entity::User::UserEntity.build_with_id(
      id: id,
      first_name: first_name,
      last_name: last_name,
      email: email
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
    subject(:result) { repo.get_by_id('00000000-0000-0000-0000-000000000001') }

    let(:infra_entity) do
      Infrastructure::Entity::User::UserEntity.new(
        id: '00000000-0000-0000-0000-000000000001',
        first_name: 'Hanako',
        last_name: 'Suzuki',
        email: 'hanako@example.com'
      )
    end
    let(:rom) { instance_double(Infrastructure::Repository::Rom::User::UserRomRepository) }

    before do
      allow(rom).to receive(:rom_get_by_id)
        .with('00000000-0000-0000-0000-000000000001')
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
      expect(rom).to have_received(:rom_get_by_id).with('00000000-0000-0000-0000-000000000001')
    end
  end

  context 'when not found by id' do
    subject(:result) { repo.get_by_id('00000000-0000-0000-0000-000000000001') }

    let(:rom) { instance_double(Infrastructure::Repository::Rom::User::UserRomRepository) }

    before do
      allow(rom).to receive(:rom_get_by_id)
        .with('00000000-0000-0000-0000-000000000001')
        .and_return(nil)
      allow(repo).to receive(:resolve).and_return(rom)
    end

    it 'returns nil' do
      expect(result).to be_nil
    end

    it 'delegates to rom_get_by_id' do
      result
      expect(rom).to have_received(:rom_get_by_id).with('00000000-0000-0000-0000-000000000001')
    end
  end

  context 'when creating a user' do
    subject(:result) { repo.create(domain) }

    let(:domain) do
      build_domain_user(id: '00000000-0000-0000-0000-000000000001', first_name: 'Ken', last_name: 'Tanaka',
                        email: 'ken@example.com')
    end

    let(:created_struct) do
      Struct.new(:id, :first_name, :last_name, :email).new(
        '00000000-0000-0000-0000-000000000001',
        'Ken',
        'Tanaka',
        'ken@example.com'
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
    subject(:result) { repo.update(domain) }

    let(:domain) do
      build_domain_user(id: '00000000-0000-0000-0000-000000000001', first_name: 'New', last_name: 'Name',
                        email: 'new@example.com')
    end
    let(:updated_struct) do
      Struct.new(:id, :first_name, :last_name, :email).new(
        '00000000-0000-0000-0000-000000000001',
        'New',
        'Name',
        'new@example.com'
      )
    end
    let(:rom) { instance_double(Infrastructure::Repository::Rom::User::UserRomRepository) }

    before do
      allow(rom).to receive(:rom_update)
        .with(instance_of(Infrastructure::Entity::User::UserEntity))
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
      expect(rom).to have_received(:rom_update).with(instance_of(Infrastructure::Entity::User::UserEntity))
    end
  end

  context 'when finding by email' do
    subject(:find_result) { repo.find_by_email('x@example.com') }

    let(:rom) { instance_double(Infrastructure::Repository::Rom::User::UserRomRepository) }

    before do
      allow(rom).to receive(:find_by_email).with('x@example.com').and_return(nil)
      allow(repo).to receive(:resolve).and_return(rom)
    end

    it 'returns nil when not found' do
      expect(find_result).to be_nil
    end

    it 'delegates to rom' do
      find_result
      expect(rom).to have_received(:find_by_email).with('x@example.com')
    end
  end
end
