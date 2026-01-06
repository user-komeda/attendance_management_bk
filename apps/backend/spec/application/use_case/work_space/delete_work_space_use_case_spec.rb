# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::WorkSpace::DeleteWorkSpaceUseCase do
  let(:use_case) do
    described_class.new.tap do |uc|
      allow(uc).to receive(:resolve).with(described_class::WORK_SPACE_REPOSITORY).and_return(work_space_repo)
    end
  end

  let(:workspace_id) { SecureRandom.uuid }
  let(:workspace_entity) do
    Domain::Entity::WorkSpace::WorkSpaceEntity.build_with_id(
      id: workspace_id,
      name: 'Test WorkSpace',
      slug: 'test-workspace'
    )
  end
  let(:work_space_repo) { instance_double(Domain::Repository::WorkSpace::WorkSpaceRepository) }


  describe '#invoke' do
    context 'when workspace exists' do
      before do
        allow(work_space_repo).to receive(:get_by_id).with(id: workspace_id).and_return(workspace_entity)
        allow(work_space_repo).to receive(:delete_by_id).with(id: workspace_id)
      end

      it 'deletes the workspace' do
        use_case.invoke(args: workspace_id)
        expect(work_space_repo).to have_received(:delete_by_id).with(id: workspace_id)
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
