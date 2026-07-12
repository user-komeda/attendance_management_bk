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

  def input_dto
    Application::Dto::WorkSpace::GetAllWorkSpaceInputDto.build(
      page: Constant::Pagination::DEFAULT_PAGE_NUMBER,
      per_page: Constant::Pagination::DEFAULT_PAGE_SIZE,
      search_query: nil
    )
  end

  def workspace_entity
    Domain::Entity::WorkSpace::WorkSpaceEntity.build_with_id(
      id: workspace_id,
      name: 'Test WorkSpace',
      slug: 'test-workspace'
    )
  end

  describe '#invoke' do
    it 'returns data' do
      mock_repos(workspace_id, 'active', [workspace_entity], 1)
      expect(use_case.invoke(arg: input_dto)[:data].first.work_spaces.id).to eq(workspace_id)
    end

    it 'returns total_count' do
      mock_repos(workspace_id, 'active', [workspace_entity], 1)
      expect(use_case.invoke(arg: input_dto)[:total_count]).to eq(1)
    end

    it 'returns empty data when no memberships' do
      allow(membership_repo).to receive(:work_space_ids_via_membership_by_user_id).with(user_id: user_id).and_return([])
      expect(use_case.invoke(arg: input_dto)[:data]).to eq([])
    end

    it 'returns zero total_count when no memberships' do
      allow(membership_repo).to receive(:work_space_ids_via_membership_by_user_id).with(user_id: user_id).and_return([])
      expect(use_case.invoke(arg: input_dto)[:total_count]).to eq(0)
    end
  end

  def mock_repos(ws_id, status, entities, total)
    allow(membership_repo).to receive(:work_space_ids_via_membership_by_user_id).and_return([[ws_id, status]])
    allow(work_space_repo).to receive(:find_by_ids_with_pagination).and_return({ data: entities, total_count: total })
  end
end
