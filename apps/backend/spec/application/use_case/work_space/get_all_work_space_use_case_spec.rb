# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::WorkSpace::GetAllWorkSpaceUseCase do
  let(:use_case) do
    described_class.new.tap do |uc|
      allow(uc).to receive(:resolve).with(described_class::WORK_SPACE_REPOSITORY).and_return(work_space_repo)
      allow(uc).to receive(:resolve).with(described_class::MEMBER_SHIPS_REPOSITORY).and_return(membership_repo)
    end
  end

  let(:user_id) { SecureRandom.uuid }
  let(:workspace_id) { SecureRandom.uuid }
  let(:work_space_repo) { instance_double(Domain::Repository::WorkSpace::WorkSpaceRepository) }
  let(:membership_repo) { instance_double(Domain::Repository::WorkSpace::MemberShipsRepository) }

  before do
    allow(ContextHelper).to receive(:get_context).with(:auth_context).and_return({ user_id: user_id })
  end

  private

  def workspace_entity
    Domain::Entity::WorkSpace::WorkSpaceEntity.build_with_id(
      id: workspace_id,
      name: 'Test WorkSpace',
      slug: 'test-workspace'
    )
  end

  describe '#invoke' do
    it 'returns an array of WorkSpaceWithStatusDto' do
      allow(membership_repo).to receive(:work_space_ids_via_membership_by_user_id)
        .and_return([[workspace_id, 'active']])
      allow(work_space_repo).to receive(:find_by_ids).and_return([workspace_entity])

      result = use_case.invoke
      expect(result.first.work_spaces.id).to eq(workspace_id)
    end

    it 'returns an empty array when no memberships' do
      allow(membership_repo).to receive(:work_space_ids_via_membership_by_user_id)
        .with(user_id: user_id)
        .and_return([])

      # .transpose on empty array returns empty array, but zip will also be empty
      result = use_case.invoke
      expect(result).to eq([])
    end
  end
end
