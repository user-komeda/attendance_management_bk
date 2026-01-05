# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::WorkSpace::CreateWorkSpaceInputDto do
  let(:params) do
    {
      name: 'Test WorkSpace',
      slug: 'test-workspace'
    }
  end

  describe '#initialize' do
    subject(:dto) { described_class.new(params: params) }

    it 'assigns name' do
      expect(dto.name).to eq('Test WorkSpace')
    end

    it 'assigns slug' do
      expect(dto.slug).to eq('test-workspace')
    end
  end

  describe '#convert_to_entity' do
    subject(:entity) { described_class.new(params: params).convert_to_entity }

    it 'returns a WorkSpaceEntity' do
      expect(entity).to be_a(Domain::Entity::WorkSpace::WorkSpaceEntity)
    end

    it 'sets name' do
      expect(entity.name).to eq('Test WorkSpace')
    end

    it 'sets slug' do
      expect(entity.slug).to eq('test-workspace')
    end
  end

  describe '#create_member_ships_entity' do
    subject(:entity) do
      described_class.new(params: params).create_member_ships_entity(
        user_id: user_id,
        workspace_id: workspace_id
      )
    end

    let(:user_id) { SecureRandom.uuid }
    let(:workspace_id) { SecureRandom.uuid }

    it 'returns a MemberShipsEntity' do
      expect(entity).to be_a(Domain::Entity::WorkSpace::MemberShipsEntity)
    end

    it 'sets user_id' do
      expect(entity.user_id.value).to eq(user_id)
    end

    it 'sets work_space_id' do
      expect(entity.work_space_id.value).to eq(workspace_id)
    end

    it 'sets role as owner' do
      expect(entity.role.value).to eq('owner')
    end

    it 'sets status as active' do
      expect(entity.status.value).to eq('active')
    end
  end
end
