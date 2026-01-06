# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Repository::WorkSpace::WorkSpaceRepository do
  let(:repository) do
    described_class.new.tap do |repo|
      allow(repo).to receive(:resolve).with(described_class::ROM_REPOSITORY_KEY).and_return(rom_repo)
    end
  end

  let(:workspace_id) { SecureRandom.uuid }
  let(:slug) { 'test-workspace' }
  let(:rom_repo) { instance_double(Infrastructure::Repository::Rom::WorkSpace::WorkSpaceRomRepository) }

  private

  def infra_entity
    Infrastructure::Entity::WorkSpace::WorkSpaceEntity.new(
      id: workspace_id,
      name: 'Test WorkSpace',
      slug: slug
    )
  end

  def domain_entity
    infra_entity.to_domain
  end

  public

  describe '#find_by_ids' do
    before do
      allow(rom_repo).to receive(:find_by_ids).with(workspace_ids: [workspace_id]).and_return([infra_entity])
    end

    it 'returns an array of domain entities' do
      result = repository.find_by_ids(workspace_ids: [workspace_id])
      expect(result.first).to be_a(Domain::Entity::WorkSpace::WorkSpaceEntity)
    end

    it 'returns correct id' do
      result = repository.find_by_ids(workspace_ids: [workspace_id])
      expect(result.first.id.value).to eq(workspace_id)
    end
  end

  describe '#find_by_slug' do
    before do
      allow(rom_repo).to receive(:find_by_slug).with(slug: slug).and_return(infra_entity)
    end

    it 'returns a domain entity' do
      result = repository.find_by_slug(slug: slug)
      expect(result).to be_a(Domain::Entity::WorkSpace::WorkSpaceEntity)
    end

    it 'returns correct slug' do
      result = repository.find_by_slug(slug: slug)
      expect(result.slug).to eq(slug)
    end
  end

  describe '#get_by_id' do
    before do
      allow(rom_repo).to receive(:rom_get_by_id).with(id: workspace_id).and_return(infra_entity)
    end

    it 'returns a domain entity' do
      result = repository.get_by_id(id: workspace_id)
      expect(result).to be_a(Domain::Entity::WorkSpace::WorkSpaceEntity)
    end

    it 'returns correct id' do
      result = repository.get_by_id(id: workspace_id)
      expect(result.id.value).to eq(workspace_id)
    end
  end

  describe '#create' do
    before do
      allow(rom_repo).to receive(:rom_create).and_return(infra_entity)
    end

    it 'returns a domain entity' do
      result = repository.create(workspace_entity: domain_entity)
      expect(result).to be_a(Domain::Entity::WorkSpace::WorkSpaceEntity)
    end

    it 'returns correct id' do
      result = repository.create(workspace_entity: domain_entity)
      expect(result.id.value).to eq(workspace_id)
    end
  end

  describe '#update' do
    before do
      allow(rom_repo).to receive(:rom_update).and_return(infra_entity)
    end

    it 'returns a domain entity' do
      result = repository.update(workspace_entity: domain_entity)
      expect(result).to be_a(Domain::Entity::WorkSpace::WorkSpaceEntity)
    end

    it 'returns correct id' do
      result = repository.update(workspace_entity: domain_entity)
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
