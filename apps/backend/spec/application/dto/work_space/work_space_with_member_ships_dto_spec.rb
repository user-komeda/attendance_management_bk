# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::WorkSpace::WorkSpaceWithMemberShipsDto do
  describe '.build' do
    subject(:dto) do
      described_class.build(
        work_space_entity: work_space_entity,
        member_ships: member_ships_entity,
        content_apis: [Domain::Entity::WorkSpace::ContentApiEntity.build_with_id(
          id: SecureRandom.uuid,
          work_space_id: workspace_id,
          name: 'articles',
          endpoint: 'articles',
          api_type: 'list'
        )]
      )
    end

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

    it 'contains content_api_names' do
      expect(dto.content_api_names).to eq(['articles'])
    end

    it 'contains content_apis with api_type' do
      expect(dto.content_apis).to eq([{ name: 'articles', api_type: 'list' }])
    end
  end
end
