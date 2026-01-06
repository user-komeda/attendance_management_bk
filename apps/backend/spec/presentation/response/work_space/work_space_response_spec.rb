# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Response::WorkSpace::WorkSpaceResponse do
  let(:workspace_id) { SecureRandom.uuid }
  let(:dto) do
    instance_double(
      Application::Dto::WorkSpace::WorkSpaceDto,
      id: workspace_id,
      name: 'Test WorkSpace',
      slug: 'test-workspace'
    )
  end

  describe '.build' do
    subject(:result) { described_class.build(work_space: dto) }

    it 'returns a hash representation' do
      expect(result).to eq({ id: workspace_id, name: 'Test WorkSpace', slug: 'test-workspace' })
    end
  end

  describe '.build_from_array' do
    subject(:result) { described_class.build_from_array(work_space_list: [dto]) }

    it 'returns an array of hashes' do
      expect(result).to eq([{ id: workspace_id, name: 'Test WorkSpace', slug: 'test-workspace' }])
    end
  end
end
