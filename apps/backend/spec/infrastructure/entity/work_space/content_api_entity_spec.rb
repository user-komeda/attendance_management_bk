# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Entity::WorkSpace::ContentApiEntity do
  let(:id) { SecureRandom.uuid }
  let(:work_space_id) { SecureRandom.uuid }
  let(:name) { 'Test API' }
  let(:endpoint) { 'https://example.com/api' }
  let(:api_type) { 'REST' }

  describe '#to_domain' do
    subject(:domain) do
      described_class.new(
        id: id,
        work_space_id: work_space_id,
        name: name,
        endpoint: endpoint,
        api_type: api_type
      ).to_domain
    end

    it 'returns a Domain::Entity::WorkSpace::ContentApiEntity' do
      expect(domain).to be_a(Domain::Entity::WorkSpace::ContentApiEntity)
    end

    it 'sets id' do
      expect(domain.id.value).to eq(id)
    end

    it 'sets work_space_id' do
      expect(domain.work_space_id.value).to eq(work_space_id)
    end

    it 'sets name' do
      expect(domain.name).to eq(name)
    end

    it 'sets endpoint' do
      expect(domain.endpoint).to eq(endpoint)
    end

    it 'sets api_type' do
      expect(domain.api_type).to eq(api_type)
    end
  end

  describe '.build_from_domain_entity' do
    def domain_entity_with_id
      Domain::Entity::WorkSpace::ContentApiEntity.build_with_id(
        id: id,
        work_space_id: work_space_id,
        name: name,
        endpoint: endpoint,
        api_type: api_type
      )
    end

    def domain_entity_without_id
      Domain::Entity::WorkSpace::ContentApiEntity.build(
        work_space_id: work_space_id,
        name: name,
        endpoint: endpoint,
        api_type: api_type
      )
    end

    it 'uses existing id when entity has an id' do
      result = described_class.build_from_domain_entity(content_api_entity: domain_entity_with_id)
      expect(result.id).to eq(id)
    end

    it 'generates a new uuid when entity has no id' do
      result = described_class.build_from_domain_entity(content_api_entity: domain_entity_without_id)
      expect(result.id).to match(/\A[0-9a-f-]{36}\z/)
    end
  end

  describe '.struct_to_domain' do
    subject(:domain) do
      struct = Struct.new(:id, :work_space_id, :name, :endpoint, :api_type).new(
        id, work_space_id, name, endpoint, api_type
      )
      described_class.struct_to_domain(struct: struct)
    end

    it 'returns a Domain::Entity::WorkSpace::ContentApiEntity' do
      expect(domain).to be_a(Domain::Entity::WorkSpace::ContentApiEntity)
    end

    it 'sets id' do
      expect(domain.id.value).to eq(id)
    end

    it 'sets work_space_id' do
      expect(domain.work_space_id.value).to eq(work_space_id)
    end

    it 'sets name' do
      expect(domain.name).to eq(name)
    end

    it 'sets endpoint' do
      expect(domain.endpoint).to eq(endpoint)
    end

    it 'sets api_type' do
      expect(domain.api_type).to eq(api_type)
    end
  end
end
