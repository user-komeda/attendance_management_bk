# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::Service::ContentApi::ContentApiService do
  subject(:service) do
    svc = described_class.allocate
    allow(svc).to receive(:resolve).with(described_class::REPOSITORY_KEY).and_return(content_api_repo)
    allow(svc).to receive(:resolve).with(described_class::WORK_SPACE_REPOSITORY_KEY).and_return(work_space_repo)
    svc
  end

  let(:content_api_repo) { instance_double(Infrastructure::Repository::ContentApi::ContentApiRepository) }
  let(:work_space_repo) { instance_double(Infrastructure::Repository::WorkSpace::WorkSpaceRepository) }
  let(:work_space_id) { SecureRandom.uuid }
  let(:endpoint) { 'articles' }
  let(:content_api_id) { SecureRandom.uuid }

  def existing_entity
    id_vo = instance_double(Domain::ValueObject::IdentityId, value: content_api_id)
    instance_double(Domain::Entity::ContentApi::ContentApiEntity, id: id_vo)
  end

  describe '#endpoint_exists?' do
    it 'returns true when endpoint exists' do
      allow(content_api_repo).to receive(:find_by_work_space_and_endpoint).and_return(existing_entity)
      expect(service.endpoint_exists?(work_space_id: work_space_id, endpoint: endpoint)).to be true
    end

    it 'returns false when endpoint does not exist' do
      allow(content_api_repo).to receive(:find_by_work_space_and_endpoint).and_return(nil)
      expect(service.endpoint_exists?(work_space_id: work_space_id, endpoint: endpoint)).to be false
    end
  end

  describe '#endpoint_exists_excluding?' do
    it 'returns false when endpoint does not exist' do
      allow(content_api_repo).to receive(:find_by_work_space_and_endpoint).and_return(nil)
      expect(service.endpoint_exists_excluding?(work_space_id: work_space_id, endpoint: endpoint,
                                                exclude_id: content_api_id)).to be false
    end

    it 'returns false when existing endpoint belongs to the excluded id' do
      allow(content_api_repo).to receive(:find_by_work_space_and_endpoint).and_return(existing_entity)
      expect(service.endpoint_exists_excluding?(work_space_id: work_space_id, endpoint: endpoint,
                                                exclude_id: content_api_id)).to be false
    end

    it 'returns true when existing endpoint belongs to a different id' do
      allow(content_api_repo).to receive(:find_by_work_space_and_endpoint).and_return(existing_entity)
      expect(service.endpoint_exists_excluding?(work_space_id: work_space_id, endpoint: endpoint,
                                                exclude_id: SecureRandom.uuid)).to be true
    end
  end

  describe '#find_work_space_by_slug' do
    it 'returns work_space entity when found' do
      work_space = double
      allow(work_space_repo).to receive(:find_by_slug).with(slug: work_space_id).and_return(work_space)
      expect(service.find_work_space_by_slug(slug: work_space_id)).to eq(work_space)
    end

    it 'returns nil when not found' do
      allow(work_space_repo).to receive(:find_by_slug).with(slug: work_space_id).and_return(nil)
      expect(service.find_work_space_by_slug(slug: work_space_id)).to be_nil
    end
  end

  describe '#duplicate_field_id?' do
    it 'returns true when field_ids are duplicated' do
      expect(service.duplicate_field_id?(field_ids: %w[title title body])).to be true
    end

    it 'returns false when field_ids are unique' do
      expect(service.duplicate_field_id?(field_ids: %w[title body])).to be false
    end
  end
end
