# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Repository::Rom::WorkSpace::WorkSpaceRomRepository do
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

      def by_ids(_ids)
        self
      end

      def by_slug(_slug)
        self
      end

      def by_pk(_id)
        self
      end

      def one
        rows.first
      end
    end
  end
  let(:repo) { create_repo_instance }
  let(:workspace_id) { SecureRandom.uuid }
  let(:infra_entity) { build_infra_entity(id: workspace_id) }

  def build_infra_entity(id: SecureRandom.uuid, name: 'Test WorkSpace', slug: 'test-workspace')
    Infrastructure::Entity::WorkSpace::WorkSpaceEntity.new(id: id, name: name, slug: slug)
  end

  def create_repo_instance
    mock_container = instance_double(Object)
    repo = described_class.allocate
    repo.instance_variable_set(:@container, mock_container)
    repo.send(:initialize, container: mock_container)
    repo
  end

  describe '#find_by_ids' do
    let(:fake_work_spaces) { fake_relation_class.new([infra_entity]) }

    before do
      allow(repo).to receive(:work_spaces).and_return(fake_work_spaces)
    end

    it 'returns an array of infra entities' do
      result = repo.find_by_ids(workspace_ids: [workspace_id])
      expect(result.first).to have_attributes(
        class: Infrastructure::Entity::WorkSpace::WorkSpaceEntity,
        id: workspace_id
      )
    end
  end

  describe '#find_by_slug' do
    let(:fake_work_spaces) { fake_relation_class.new([infra_entity]) }

    before do
      allow(repo).to receive(:work_spaces).and_return(fake_work_spaces)
    end

    it 'returns one infra entity' do
      result = repo.find_by_slug(slug: 'test-workspace')
      expect(result).to have_attributes(
        class: Infrastructure::Entity::WorkSpace::WorkSpaceEntity,
        slug: 'test-workspace'
      )
    end
  end

  describe '#rom_get_by_id' do
    let(:fake_work_spaces) { fake_relation_class.new([infra_entity]) }

    before do
      allow(repo).to receive(:work_spaces).and_return(fake_work_spaces)
    end

    it 'returns one infra entity' do
      result = repo.rom_get_by_id(id: workspace_id)
      expect(result).to have_attributes(
        class: Infrastructure::Entity::WorkSpace::WorkSpaceEntity,
        id: workspace_id
      )
    end
  end

  describe '#rom_create' do
    it 'delegates to command' do
      allow(repo).to receive(:create).with(infra_entity).and_return(infra_entity)
      expect(repo.rom_create(workspace_entity: infra_entity)).to eq(infra_entity)
    end
  end

  describe '#rom_update' do
    it 'delegates to command' do
      allow(repo).to receive(:update).with(workspace_id,
                                           { name: 'Test WorkSpace', slug: 'test-workspace' }).and_return(infra_entity)
      expect(repo.rom_update(workspace_entity: infra_entity)).to eq(infra_entity)
    end
  end

  describe '#rom_delete' do
    it 'delegates to command' do
      allow(repo).to receive(:delete).with(workspace_id).and_return(infra_entity)
      expect(repo.rom_delete(id: workspace_id)).to eq(infra_entity)
    end
  end
end
