# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::WorkSpace::GetDetailWorkSpaceUseCase do
  subject(:use_case) { described_class.new }

  let(:user_id) { SecureRandom.uuid }
  let(:workspace_id) { SecureRandom.uuid }
  let(:membership_id) { SecureRandom.uuid }
  let(:work_space_repo) { instance_double(Domain::Repository::WorkSpace::WorkSpaceRepository) }
  let(:membership_repo) { instance_double(Domain::Repository::WorkSpace::MemberShipsRepository) }
  let(:workspace_entity) do
    Domain::Entity::WorkSpace::WorkSpaceEntity.build_with_id(
      id: workspace_id,
      name: 'Test WorkSpace',
      slug: 'test-workspace'
    )
  end
  let(:membership_entity) do
    Domain::Entity::WorkSpace::MemberShipsEntity.build_with_id(
      id: membership_id,
      user_id: user_id,
      work_space_id: workspace_id,
      role: 'owner',
      status: 'active'
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
    context 'when workspace exists' do
      before do
        allow(work_space_repo).to receive(:get_by_id).with(id: workspace_id).and_return(workspace_entity)
        allow(membership_repo).to receive(:get_by_user_id_and_work_space_id)
          .with(user_id: user_id, work_space_id: workspace_id)
          .and_return(membership_entity)
      end

      it 'returns WorkSpaceWithMemberShipsDto' do
        result = use_case.invoke(args: workspace_id)
        expect(result).to be_a(Application::Dto::WorkSpace::WorkSpaceWithMemberShipsDto)
        expect(result.work_spaces.id).to eq(workspace_id)
        expect(result.member_ships.id).to eq(membership_id)
      end
    end

    context 'when workspace does not exist' do
      before do
        allow(work_space_repo).to receive(:get_by_id).with(id: workspace_id).and_return(nil)
      end

      it 'raises NotFoundException' do
        expect { use_case.invoke(args: workspace_id) }
          .to raise_error(Application::Exception::NotFoundException, 'workspace not found')
      end
    end
  end
end
