# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::WorkSpace::GetDetailWorkSpaceUseCase do
  let(:workspace_id) { SecureRandom.uuid }

  describe '#invoke' do
    subject(:use_case) do
      described_class.new.tap do |uc|
        allow(uc).to receive(:resolve).with(described_class::WORK_SPACE_REPOSITORY).and_return(work_space_repo)
        allow(uc).to receive(:resolve).with(described_class::MEMBER_SHIPS_REPOSITORY).and_return(membership_repo)
        allow(uc).to receive(:resolve).with(described_class::CONTENT_API_REPOSITORY).and_return(content_api_repo)
      end
    end

    let(:work_space_repo) { instance_double(Domain::Repository::WorkSpace::WorkSpaceRepository) }
    let(:membership_repo) { instance_double(Domain::Repository::WorkSpace::MemberShipsRepository) }
    let(:content_api_repo) { instance_double(Domain::Repository::WorkSpace::ContentApiRepository) }

    context 'when workspace exists' do
      before do
        workspace_entity = Domain::Entity::WorkSpace::WorkSpaceEntity.build_with_id(
          id: workspace_id, name: 'Test WorkSpace', slug: 'test-workspace'
        )
        membership_entity = Domain::Entity::WorkSpace::MemberShipsEntity.build_with_id(
          id: SecureRandom.uuid,
          user_id: SecureRandom.uuid,
          work_space_id: workspace_id,
          role: 'owner',
          status: 'active'
        )
        content_api_entity = Domain::Entity::WorkSpace::ContentApiEntity.build_with_id(
          id: SecureRandom.uuid, work_space_id: workspace_id, name: 'articles', endpoint: 'articles', api_type: 'list'
        )
        allow(work_space_repo).to receive(:find_by_slug).with(slug: workspace_id).and_return(workspace_entity)
        allow(membership_repo).to receive(:get_by_work_space_id)
          .with(work_space_id: workspace_id)
          .and_return([membership_entity])
        allow(content_api_repo).to receive(:get_by_work_space_id)
          .with(work_space_id: workspace_id).and_return([content_api_entity])
      end

      it 'returns workspace dto with workspace id and memberships' do
        result = use_case.invoke(arg: workspace_id)
        aggregate_failures do
          expect(result.work_spaces.id).to eq(workspace_id)
          expect(result.member_ships.size).to eq(1)
        end
      end

      it 'returns workspace dto with content apis' do
        result = use_case.invoke(arg: workspace_id)
        aggregate_failures do
          expect(result.content_api_names).to eq(['articles'])
          expect(result.content_apis).to eq([{ name: 'articles', api_type: 'list' }])
        end
      end
    end

    context 'when workspace does not exist' do
      before do
        allow(work_space_repo).to receive(:find_by_slug).with(slug: workspace_id).and_return(nil)
      end

      it 'raises NotFoundException' do
        expect { use_case.invoke(arg: workspace_id) }
          .to raise_error(Application::Exception::NotFoundException, 'workspace not found')
      end
    end
  end
end
