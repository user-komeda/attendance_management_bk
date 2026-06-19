# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Response::WorkSpace::WorkSpaceWithStatusResponse do
  let(:workspace_id) { SecureRandom.uuid }
  let(:dto) do
    instance_double(
      Application::Dto::WorkSpace::WorkSpaceDto,
      id: workspace_id,
      name: 'Test',
      slug: 'test'
    )
  end

  describe '.build_from_array' do
    subject(:result) do
      described_class.build_from_array(
        status_list: ['active'],
        work_spaces: [dto],
        pagination: pagination,
        total_count: total_count
      )
    end

    let(:pagination) { { page: 1, per_page: 10 } }
    let(:total_count) { 1 }

    it 'returns an array of hash representations' do
      aggregate_failures do
        expect(result[:data].first[:status]).to eq('active')
        expect(result[:data].first[:id]).to eq(workspace_id)
        expect(result[:data].first[:name]).to eq('Test')
      end
    end

    describe 'data collection' do
      let(:compact_result) do
        described_class.build_from_array(
          status_list: ['active', nil],
          work_spaces: [dto, nil],
          pagination: pagination,
          total_count: total_count
        )
      end

      it 'compacts nil elements' do
        expect(compact_result[:data].size).to eq(1)
      end
    end
  end
end
