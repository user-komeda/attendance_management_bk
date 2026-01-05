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
    it 'returns an array of hash representations' do
      result = described_class.build_from_array(
        status_list: ['active'],
        work_spaces: [dto]
      )
      expect(result.first[:status]).to eq('active')
      expect(result.first[:id]).to eq(workspace_id)
      expect(result.first[:name]).to eq('Test')
    end

    it 'compacts nil elements' do
      result = described_class.build_from_array(
        status_list: ['active', nil],
        work_spaces: [dto, nil]
      )
      expect(result.size).to eq(1)
    end
  end
end
