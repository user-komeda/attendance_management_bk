# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Repository::Rom::User::UserRomRepository do
  let(:fake_relation_class) do
    Class.new do
      attr_accessor :rows, :mapped_class

      def initialize(rows, mapped_class = nil)
        @rows = rows
        @mapped_class = mapped_class
      end

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
  end

  def build_infra_entity(id: '1', first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
    Infrastructure::Entity::User::UserEntity.new(id: id, first_name: first_name, last_name: last_name, email: email,
                                                 session_version: 1)
  end

  def create_repo_instance
    mock_container = instance_double(Object)
    repo = described_class.allocate
    repo.instance_variable_set(:@container, mock_container)
    repo.send(:initialize, container: mock_container)
    repo
  end

  context 'when rom_get_all is called' do
    subject(:result) { repo.rom_get_all }

    let(:repo) { create_repo_instance }
    let(:mapped) do
      [
        build_infra_entity(id: '00000000-0000-0000-0000-000000000001'),
        build_infra_entity(id: '00000000-0000-0000-0000-000000000002', first_name: 'Hanako', last_name: 'Suzuki',
                           email: 'hanako@example.com')
      ]
    end
    let(:fake_users) { fake_relation_class.new(mapped, nil) }

    before do
      allow(repo).to receive(:users).and_return(fake_users)
    end

    it 'returns two records' do
      expect(result.size).to eq(2)
    end

    it 'maps to infra entities' do
      expect(result.first).to be_a(Infrastructure::Entity::User::UserEntity)
    end

    it 'maps id correctly' do
      expect(result.first.id).to eq('00000000-0000-0000-0000-000000000001')
    end

    it 'maps first_name correctly for second record' do
      expect(result.last.first_name).to eq('Hanako')
    end
  end

  context 'when rom_get_by_id is called' do
    subject(:result) { repo.rom_get_by_id(id: '00000000-0000-0000-0000-000000000001') }

    let(:repo) { create_repo_instance }
    let(:fake_users) do
      fake_relation_class.new(
        [build_infra_entity(id: '00000000-0000-0000-0000-000000000001', first_name: 'Ken', last_name: 'Tanaka',
                            email: 'ken@example.com')], nil
      )
    end

    before do
      allow(repo).to receive(:users).and_return(fake_users)
    end

    it 'returns infra entity' do
      expect(result).to be_a(Infrastructure::Entity::User::UserEntity)
    end

    it 'has expected first_name' do
      expect(result.first_name).to eq('Ken')
    end
  end

  context 'when rom_create is called' do
    subject(:result) { repo.rom_create(user_entity: input) }

    let(:repo) { create_repo_instance }
    let(:input) do
      build_infra_entity(id: '00000000-0000-0000-0000-000000000001', first_name: 'A', last_name: 'B',
                         email: 'a@example.com')
    end
    let(:created) do
      build_infra_entity(id: '00000000-0000-0000-0000-000000000001', first_name: 'A', last_name: 'B',
                         email: 'a@example.com')
    end

    before do
      allow(repo).to receive(:create).and_return(created)
    end

    it 'returns created id' do
      expect(result.id).to eq('00000000-0000-0000-0000-000000000001')
    end

    it 'returns created first_name' do
      expect(result.first_name).to eq('A')
    end
  end

  context 'when rom_update is called' do
    subject(:result) { repo.rom_update(user_entity: input) }

    let(:repo) { create_repo_instance }
    let(:input) do
      build_infra_entity(id: '00000000-0000-0000-0000-000000000001', first_name: 'New', last_name: 'Name',
                         email: 'new@example.com')
    end
    let(:updated) do
      build_infra_entity(id: '00000000-0000-0000-0000-000000000001', first_name: 'New', last_name: 'Name',
                         email: 'new@example.com')
    end
    let(:called) { [] }

    before do
      allow(repo).to receive(:update) do |id, attrs|
        called << [id, attrs]
        updated
      end
    end

    it 'returns updated id' do
      expect(result.id).to eq('00000000-0000-0000-0000-000000000001')
    end

    it 'passes sliced fields to update' do
      # ensure subject is evaluated so the stubbed update is called
      result
      expect(called.first[1].keys.sort).to eq(%i[first_name last_name email].sort)
    end

    it 'passes id to update' do
      # ensure subject is evaluated so the stubbed update is called
      result
      expect(called.first[0]).to eq('00000000-0000-0000-0000-000000000001')
    end
  end

  context 'when finding by email' do
    subject(:result) { repo.find_by_email(email: 'x@example.com') }

    let(:repo) { create_repo_instance }
    let(:fake_users) do
      fake_relation_class.new(
        [build_infra_entity(id: '00000000-0000-0000-0000-000000000001', first_name: 'X', last_name: 'Y',
                            email: 'x@example.com')], nil
      )
    end

    before do
      allow(repo).to receive(:users).and_return(fake_users)
    end

    it 'returns an infra entity' do
      expect(result).to be_a(Infrastructure::Entity::User::UserEntity)
    end

    it 'returns the matched email' do
      expect(result.email).to eq('x@example.com')
    end
  end
end
