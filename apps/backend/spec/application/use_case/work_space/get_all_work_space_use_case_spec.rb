# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::WorkSpace::GetAllWorkSpaceUseCase do
  subject(:use_case) { described_class.new }

  let(:user_id) { SecureRandom.uuid }
  let(:workspace_id) { SecureRandom.uuid }
  let(:work_space_repo) { instance_double(Domain::Repository::WorkSpace::WorkSpaceRepository) }
  let(:membership_repo) { instance_double(Domain::Repository::WorkSpace::MemberShipsRepository) }
  let(:workspace_entity) do
    Domain::Entity::WorkSpace::WorkSpaceEntity.build_with_id(
      id: workspace_id,
      name: 'Test WorkSpace',
      slug: 'test-workspace'
    )
  end

  before do
    allow(ContextHelper).to receive(:get_context).with(:auth_context).and_return({ user_id: user_id })
    # rubocop:disable RSpec/SubjectStub
    allow(use_case).to receive(:resolve) do |key|
      case key
      when described_class::WORK_SPACE_REPOSITORY
        work_space_repo
      when described_class::MEMBER_SHIPS_REPOSITORY
        membership_repo
      else
        raise "Unexpected key: #{key}"
      end
    end
    # rubocop:enable RSpec/SubjectStub
  end

  describe '#invoke' do
    it 'returns an array of WorkSpaceWithStatusDto' do
      allow(membership_repo).to receive(:work_space_ids_via_membership_by_user_id)
        .with(user_id: user_id)
        .and_return([[workspace_id, 'active']])
      allow(work_space_repo).to receive(:find_by_ids)
        .with(workspace_ids: [workspace_id])
        .and_return([workspace_entity])

      result = use_case.invoke
      expect(result).to be_an(Array)
      expect(result.first).to be_a(Application::Dto::WorkSpace::WorkSpaceWithStatusDto)
      expect(result.first.work_spaces.id).to eq(workspace_id)
      expect(result.first.status).to eq('active')
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
