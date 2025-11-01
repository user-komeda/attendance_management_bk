# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Infrastructure::Repository::Rom::User::UserRomRepository do
  FakeRelation = Struct.new(:rows, :mapped_class) do
    def map_to(klass)
      self.mapped_class = klass
      self
    end

    def to_a
      rows
    end

    def by_pk(_id)
      self
    end

    def one
      rows.first
    end

    def by_email(_email)
      self
    end

    def first
      rows.first
    end
  end

  def build_infra_entity(id: '1', first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
    ::Infrastructure::Entity::User::UserEntity.new(id: id, first_name: first_name, last_name: last_name, email: email)
  end

  # 繧ｳ繝ｳ繝・リ萓晏ｭ俶ｧ繧偵Δ繝・け蛹悶＠縺ｦ繝ｪ繝昴ず繝医Μ繧､繝ｳ繧ｹ繧ｿ繝ｳ繧ｹ繧剃ｽ懈・
  def create_repo_instance
    mock_container = double('Container')
    repo = described_class.allocate
    repo.instance_variable_set(:@container, mock_container)
    repo.send(:initialize, container: mock_container)
    repo
  end

  it 'maps rom_get_all to domain entities' do
    repo = create_repo_instance
    mapped = [build_infra_entity(id: '00000000-0000-0000-0000-000000000001'), build_infra_entity(id: '00000000-0000-0000-0000-000000000002', first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com')]
    fake_users = FakeRelation.new(mapped, nil)

    allow(repo).to receive(:users).and_return(fake_users)

    result = repo.rom_get_all
    expect(result.size).to eq(2)
    expect(result.first).to be_a(::Domain::Entity::User::UserEntity)
    expect(result.first.id.value).to eq('00000000-0000-0000-0000-000000000001')
    expect(result.last.user_name.first_name).to eq('Hanako')
  end

  it 'returns infra entity on rom_get_by_id' do
    repo = create_repo_instance
    fake_users = FakeRelation.new([build_infra_entity(id: '00000000-0000-0000-0000-000000000001', first_name: 'Ken', last_name: 'Tanaka', email: 'ken@example.com')], nil)

    allow(repo).to receive(:users).and_return(fake_users)

    result = repo.rom_get_by_id("00000000-0000-0000-0000-000000000001")
    expect(result).to be_a(::Infrastructure::Entity::User::UserEntity)
    expect(result.first_name).to eq('Ken')
  end

  it 'delegates rom_create to create' do
    repo = create_repo_instance
    input = build_infra_entity(id: '00000000-0000-0000-0000-000000000001', first_name: 'A', last_name: 'B', email: 'a@example.com')
    created = build_infra_entity(id: '00000000-0000-0000-0000-000000000001', first_name: 'A', last_name: 'B', email: 'a@example.com')

    allow(repo).to receive(:create).and_return(created)

    result = repo.rom_create(input)
    expect(result.id).to eq('00000000-0000-0000-0000-000000000001')
    expect(result.first_name).to eq('A')
  end

  it 'delegates rom_update to update with sliced fields' do
    repo = create_repo_instance
    input = build_infra_entity(id: '00000000-0000-0000-0000-000000000001', first_name: 'New', last_name: 'Name', email: 'new@example.com')
    updated = build_infra_entity(id: '00000000-0000-0000-0000-000000000001', first_name: 'New', last_name: 'Name', email: 'new@example.com')

    called = []
    allow(repo).to receive(:update) do |id, attrs|
      called << [id, attrs]
      updated
    end

    result = repo.rom_update(input)
    expect(result.id).to eq('00000000-0000-0000-0000-000000000001')
    expect(called.first[1].keys.sort).to eq([:first_name, :last_name, :email].sort)
    expect(called.first[0]).to eq('00000000-0000-0000-0000-000000000001')
  end

  it 'finds by email and returns first mapped' do
    repo = create_repo_instance
    fake_users = FakeRelation.new([build_infra_entity(id: '00000000-0000-0000-0000-000000000001', first_name: 'X', last_name: 'Y', email: 'x@example.com')], nil)

    allow(repo).to receive(:users).and_return(fake_users)

    result = repo.find_by_email('x@example.com')
    expect(result).to be_a(::Infrastructure::Entity::User::UserEntity)
    expect(result.email).to eq('x@example.com')
  end
end