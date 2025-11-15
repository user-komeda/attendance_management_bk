# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Infrastructure::Repository::User::UserRepository do
  let(:repo) { described_class.new }

  def build_domain_user(id: 1, first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
    entity = ::Domain::Entity::User::UserEntity.build(first_name: first_name, last_name: last_name, email: email)
    entity.id = ::Domain::ValueObject::IdentityId.build(id)
    entity
  end

  it 'delegates get_all to rom_get_all' do
    rom = double('RomRepo', rom_get_all: [])
    allow(repo).to receive(:resolve).and_return(rom)

    result = repo.get_all
    expect(result).to be_a(Array)
    expect(result).to be_empty
  end

  it 'returns domain entity when found by id' do
    infra_entity = ::Infrastructure::Entity::User::UserEntity.new(id: '00000000-0000-0000-0000-000000000001',
                                                                  first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com')
    rom = double('RomRepo')
    expect(rom).to receive(:rom_get_by_id).with('00000000-0000-0000-0000-000000000001').and_return(infra_entity)

    allow(repo).to receive(:resolve).and_return(rom)

    result = repo.get_by_id('00000000-0000-0000-0000-000000000001')
    expect(result).to be_a(::Domain::Entity::User::UserEntity)
    expect(result.user_name.first_name).to eq('Hanako')
  end

  it 'returns nil when not found by id' do
    rom = double('RomRepo')
    expect(rom).to receive(:rom_get_by_id).with('00000000-0000-0000-0000-000000000001').and_return(nil)

    allow(repo).to receive(:resolve).and_return(rom)

    expect(repo.get_by_id('00000000-0000-0000-0000-000000000001')).to be_nil
  end

  it 'builds infra on create and returns domain entity' do
    domain = build_domain_user(id: '00000000-0000-0000-0000-000000000001', first_name: 'Ken', last_name: 'Tanaka',
                               email: 'ken@example.com')
    created_struct = Struct.new(:id, :first_name, :last_name, :email).new('00000000-0000-0000-0000-000000000001',
                                                                          'Ken', 'Tanaka', 'ken@example.com')

    rom = double('RomRepo')
    expect(rom).to receive(:rom_create).with(instance_of(Infrastructure::Entity::User::UserEntity)).and_return(created_struct)

    allow(repo).to receive(:resolve).and_return(rom)

    result = repo.create(domain)
    expect(result).to be_a(::Domain::Entity::User::UserEntity)
    expect(result.user_name.first_name).to eq('Ken')
    expect(result.email.value).to eq('ken@example.com')
  end

  it 'builds infra on update and returns domain entity' do
    domain = build_domain_user(id: '00000000-0000-0000-0000-000000000001', first_name: 'New', last_name: 'Name',
                               email: 'new@example.com')
    updated_struct = Struct.new(:id, :first_name, :last_name, :email).new('00000000-0000-0000-0000-000000000001',
                                                                          'New', 'Name', 'new@example.com')

    rom = double('RomRepo')
    expect(rom).to receive(:rom_update).with(instance_of(Infrastructure::Entity::User::UserEntity)).and_return(updated_struct)

    allow(repo).to receive(:resolve).and_return(rom)

    result = repo.update(domain)
    expect(result).to be_a(::Domain::Entity::User::UserEntity)
    expect(result.user_name.first_name).to eq('New')
    expect(result.email.value).to eq('new@example.com')
  end

  it 'delegates find_by_email to rom repo' do
    rom = double('RomRepo')
    expect(rom).to receive(:find_by_email).with('x@example.com').and_return(nil)

    allow(repo).to receive(:resolve).and_return(rom)

    expect(repo.find_by_email('x@example.com')).to be_nil
  end
end
