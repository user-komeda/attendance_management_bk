# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::WorkSpace::WorkSpaceWithStatusDto do
  let(:workspace_id) { SecureRandom.uuid }
  let(:status) { 'active' }

  let(:work_space_entity) do
    Domain::Entity::WorkSpace::WorkSpaceEntity.new(
      id: Domain::ValueObject::IdentityId.build(workspace_id),
      name: 'Test WorkSpace',
      slug: 'test-workspace'
    )
  end

  describe '.build' do
    subject(:dto) do
      described_class.build(
        work_space_entity: work_space_entity,
        status: status
      )
    end

    it 'returns a WorkSpaceWithStatusDto' do
      expect(dto).to be_a(described_class)
    end

    it 'sets status' do
      expect(dto.status).to eq(status)
    end

    it 'contains a WorkSpaceDto' do
      expect(dto.work_spaces).to be_a(Application::Dto::WorkSpace::WorkSpaceDto)
    end

    it 'sets correct work_spaces values' do
      expect(dto.work_spaces.id).to eq(workspace_id)
    end
  end
end
