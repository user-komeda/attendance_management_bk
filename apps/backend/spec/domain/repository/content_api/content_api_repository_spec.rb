# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::Repository::ContentApi::ContentApiRepository do
  subject(:repository) do
    repo = described_class.allocate
    allow(repo).to receive(:resolve).with(described_class::REPOSITORY_KEY).and_return(infra_repo)
    repo
  end

  let(:infra_repo) { instance_double(Infrastructure::Repository::ContentApi::ContentApiRepository) }
  let(:content_api_id) { SecureRandom.uuid }
  let(:work_space_id) { SecureRandom.uuid }
  let(:content_api_entity) { instance_double(Domain::Entity::ContentApi::ContentApiEntity) }
  let(:field_entity) { instance_double(Domain::Entity::ContentApi::FieldEntity) }

  describe '#get_by_work_space_id' do
    it 'delegates to infra repository' do
      allow(infra_repo)
        .to receive(:get_by_work_space_id)
        .with(work_space_id: work_space_id)
        .and_return([content_api_entity])
      expect(repository.get_by_work_space_id(work_space_id: work_space_id)).to eq([content_api_entity])
    end
  end

  describe '#create' do
    it 'delegates to infra repository' do
      allow(infra_repo).to receive(:create).with(content_api_entity: content_api_entity).and_return(content_api_entity)
      expect(repository.create(content_api_entity: content_api_entity)).to eq(content_api_entity)
    end
  end

  describe '#find_by_id' do
    it 'delegates to infra repository' do
      allow(infra_repo).to receive(:find_by_id).with(id: content_api_id).and_return(content_api_entity)
      expect(repository.find_by_id(id: content_api_id)).to eq(content_api_entity)
    end

    it 'returns nil when not found' do
      allow(infra_repo).to receive(:find_by_id).with(id: content_api_id).and_return(nil)
      expect(repository.find_by_id(id: content_api_id)).to be_nil
    end
  end

  describe '#update' do
    it 'delegates to infra repository' do
      allow(infra_repo).to receive(:update).with(content_api_entity: content_api_entity).and_return(content_api_entity)
      expect(repository.update(content_api_entity: content_api_entity)).to eq(content_api_entity)
    end
  end

  describe '#delete_by_id' do
    it 'delegates to infra repository' do
      allow(infra_repo).to receive(:delete_by_id).with(id: content_api_id)
      repository.delete_by_id(id: content_api_id)
      expect(infra_repo).to have_received(:delete_by_id).with(id: content_api_id)
    end
  end

  describe '#bulk_create_fields' do
    it 'delegates to infra repository' do
      allow(infra_repo).to receive(:bulk_create_fields).with(content_api_id: content_api_id,
                                                             field_entities: [field_entity]).and_return([field_entity])
      expect(repository.bulk_create_fields(content_api_id: content_api_id,
                                           field_entities: [field_entity])).to eq([field_entity])
    end
  end

  describe '#get_fields_by_content_api_id' do
    it 'delegates to infra repository' do
      allow(infra_repo)
        .to receive(:get_fields_by_content_api_id)
        .with(content_api_id: content_api_id)
        .and_return([field_entity])
      expect(repository.get_fields_by_content_api_id(content_api_id: content_api_id)).to eq([field_entity])
    end
  end

  describe '#find_by_work_space_and_endpoint' do
    it 'delegates to infra repository' do
      allow(infra_repo).to receive(:find_by_work_space_and_endpoint)
        .with(work_space_id: work_space_id, endpoint: 'articles').and_return(content_api_entity)
      result = repository.find_by_work_space_and_endpoint(work_space_id: work_space_id, endpoint: 'articles')
      expect(result).to eq(content_api_entity)
    end
  end
end
