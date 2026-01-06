# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::WorkSpace::WorkSpaceWithMemberShipsDto do
  let(:workspace_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:membership_id) { SecureRandom.uuid }

  let(:work_space_entity) do
    Domain::Entity::WorkSpace::WorkSpaceEntity.new(
      id: Domain::ValueObject::IdentityId.build(workspace_id),
      name: 'Test WorkSpace',
      slug: 'test-workspace'
    )
  end

  let(:member_ships_entity) do
    Domain::Entity::WorkSpace::MemberShipsEntity.new(
      id: Domain::ValueObject::IdentityId.build(membership_id),
      user_id: Domain::ValueObject::IdentityId.build(user_id),
      work_space_id: Domain::ValueObject::IdentityId.build(workspace_id),
      role: Domain::ValueObject::WorkSpace::Role.build('owner'),
      status: Domain::ValueObject::WorkSpace::Status.build('active')
    )
  end

  describe '.build' do
    subject(:dto) do
      described_class.build(
        work_space_entity: work_space_entity,
        member_ships: member_ships_entity
      )
    end

    it 'returns a WorkSpaceWithMemberShipsDto' do
      expect(dto).to be_a(described_class)
    end

    it 'contains a MemberShipsDto' do
      expect(dto.member_ships).to be_a(Application::Dto::WorkSpace::MemberShipsDto)
    end

    it 'contains a WorkSpaceDto' do
      expect(dto.work_spaces).to be_a(Application::Dto::WorkSpace::WorkSpaceDto)
    end

    it 'sets correct member_ships values' do
      expect(dto.member_ships.id).to eq(membership_id)
    end

    it 'sets correct work_spaces values' do
      expect(dto.work_spaces.id).to eq(workspace_id)
    end
  end
end
