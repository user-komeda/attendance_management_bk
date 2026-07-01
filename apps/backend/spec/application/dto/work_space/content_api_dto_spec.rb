# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::WorkSpace::ContentApiDto do
  let(:id) { SecureRandom.uuid }
  let(:work_space_id) { SecureRandom.uuid }

  let(:content_api_entity) do
    Domain::Entity::WorkSpace::ContentApiEntity.build_with_id(
      id: id,
      work_space_id: work_space_id,
      name: 'Test API',
      endpoint: 'https://example.com/api',
      api_type: 'REST'
    )
  end

  describe '.build' do
    subject(:dto) { described_class.build(content_api_entity) }

    it 'returns a ContentApiDto' do
      expect(dto).to be_a(described_class)
    end

    it 'sets id' do
      expect(dto.id).to eq(id)
    end

    it 'sets work_space_id' do
      expect(dto.work_space_id).to eq(work_space_id)
    end

    it 'sets name' do
      expect(dto.name).to eq('Test API')
    end

    it 'sets endpoint' do
      expect(dto.endpoint).to eq('https://example.com/api')
    end

    it 'sets api_type' do
      expect(dto.api_type).to eq('REST')
    end
  end
end
