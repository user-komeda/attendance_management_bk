# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::Repository::WorkSpace::WorkSpaceRepository do
  subject(:repository) { described_class.new }

  let(:infra_repo) { instance_double(Infrastructure::Repository::WorkSpace::WorkSpaceRepository) }
  let(:workspace_entity) { instance_double(Domain::Entity::WorkSpace::WorkSpaceEntity) }
  let(:workspace_id) { SecureRandom.uuid }
  let(:slug) { 'test-workspace' }

  before do
    # rubocop:disable RSpec/SubjectStub
    allow(repository).to receive(:resolve).with(described_class::REPOSITORY_KEY).and_return(infra_repo)
    # rubocop:enable RSpec/SubjectStub
  end

  describe '#find_by_ids' do
    it 'delegates to infra repository' do
      allow(infra_repo).to receive(:find_by_ids).with(workspace_ids: [workspace_id]).and_return([workspace_entity])
      expect(repository.find_by_ids(workspace_ids: [workspace_id])).to eq([workspace_entity])
    end
  end

  describe '#find_by_slug' do
    it 'delegates to infra repository' do
      allow(infra_repo).to receive(:find_by_slug).with(slug: slug).and_return(workspace_entity)
      expect(repository.find_by_slug(slug: slug)).to eq(workspace_entity)
    end
  end

  describe '#get_by_id' do
    it 'delegates to infra repository' do
      allow(infra_repo).to receive(:get_by_id).with(id: workspace_id).and_return(workspace_entity)
      expect(repository.get_by_id(id: workspace_id)).to eq(workspace_entity)
    end
  end

  describe '#create' do
    it 'delegates to infra repository' do
      allow(infra_repo).to receive(:create).with(workspace_entity: workspace_entity).and_return(workspace_entity)
      expect(repository.create(workspace_entity: workspace_entity)).to eq(workspace_entity)
    end
  end

  describe '#update' do
    it 'delegates to infra repository' do
      allow(infra_repo).to receive(:update).with(workspace_entity: workspace_entity).and_return(workspace_entity)
      expect(repository.update(workspace_entity: workspace_entity)).to eq(workspace_entity)
    end
  end

  describe '#delete_by_id' do
    it 'delegates to infra repository' do
      allow(infra_repo).to receive(:delete_by_id).with(id: workspace_id).and_return(workspace_entity)
      expect(repository.delete_by_id(id: workspace_id)).to eq(workspace_entity)
    end
  end
end
