# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Repository::WorkSpace::WorkSpaceRepository do
  subject(:repository) { described_class.new }

  let(:rom_repo) { instance_double(Infrastructure::Repository::Rom::WorkSpace::WorkSpaceRomRepository) }
  let(:workspace_id) { SecureRandom.uuid }
  let(:slug) { 'test-workspace' }
  let(:infra_entity) do
    Infrastructure::Entity::WorkSpace::WorkSpaceEntity.new(
      id: workspace_id,
      name: 'Test WorkSpace',
      slug: slug
    )
  end
  let(:domain_entity) { infra_entity.to_domain }

  before do
    # rubocop:disable RSpec/SubjectStub
    allow(repository).to receive(:resolve).with(described_class::ROM_REPOSITORY_KEY).and_return(rom_repo)
    # rubocop:enable RSpec/SubjectStub
  end

  describe '#find_by_ids' do
    it 'returns an array of domain entities' do
      allow(rom_repo).to receive(:find_by_ids).with(workspace_ids: [workspace_id]).and_return([infra_entity])
      result = repository.find_by_ids(workspace_ids: [workspace_id])
      expect(result.first).to be_a(Domain::Entity::WorkSpace::WorkSpaceEntity)
      expect(result.first.id.value).to eq(workspace_id)
    end
  end

  describe '#find_by_slug' do
    it 'returns a domain entity' do
      allow(rom_repo).to receive(:find_by_slug).with(slug: slug).and_return(infra_entity)
      result = repository.find_by_slug(slug: slug)
      expect(result).to be_a(Domain::Entity::WorkSpace::WorkSpaceEntity)
      expect(result.slug).to eq(slug)
    end
  end

  describe '#get_by_id' do
    it 'returns a domain entity' do
      allow(rom_repo).to receive(:rom_get_by_id).with(id: workspace_id).and_return(infra_entity)
      result = repository.get_by_id(id: workspace_id)
      expect(result).to be_a(Domain::Entity::WorkSpace::WorkSpaceEntity)
      expect(result.id.value).to eq(workspace_id)
    end
  end

  describe '#create' do
    it 'creates and returns a domain entity' do
      allow(rom_repo).to receive(:rom_create).and_return(infra_entity)
      result = repository.create(workspace_entity: domain_entity)
      expect(result).to be_a(Domain::Entity::WorkSpace::WorkSpaceEntity)
      expect(result.id.value).to eq(workspace_id)
    end
  end

  describe '#update' do
    it 'updates and returns a domain entity' do
      allow(rom_repo).to receive(:rom_update).and_return(infra_entity)
      result = repository.update(workspace_entity: domain_entity)
      expect(result).to be_a(Domain::Entity::WorkSpace::WorkSpaceEntity)
      expect(result.id.value).to eq(workspace_id)
    end
  end

  describe '#delete_by_id' do
    it 'deletes and returns the id' do
      allow(rom_repo).to receive(:rom_delete).with(id: workspace_id).and_return(infra_entity)
      result = repository.delete_by_id(id: workspace_id)
      expect(result).to eq(workspace_id)
    end
  end
end
