# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::WorkSpace::UpdateWorkSpaceUseCase do
  let(:use_case) do
    described_class.new.tap do |uc|
      allow(uc).to receive(:resolve).with(described_class::WORK_SPACE_REPOSITORY).and_return(work_space_repo)
      allow(uc).to receive(:resolve).with(described_class::WORK_SPACE_SERVICE).and_return(work_space_service)
      allow(uc).to receive(:resolve).with('db.config').and_return(memoized_rom_config)
    end
  end

  let(:workspace_id) { SecureRandom.uuid }
  let(:work_space_repo) { instance_double(Domain::Repository::WorkSpace::WorkSpaceRepository) }
  let(:work_space_service) { instance_double(Domain::Service::WorkSpace::WorkSpaceService) }
  let(:memoized_rom_config) { instance_double(ROM::Configuration, gateways: { default: instance_double(ROM::Gateway) }) }

  before do
    allow(memoized_rom_config.gateways[:default]).to receive(:transaction).and_yield
  end

  private

  def input_dto
    Application::Dto::WorkSpace::UpdateWorkSpaceInputDto.new(
      id: workspace_id,
      name: 'Updated WorkSpace',
      slug: 'updated-workspace'
    )
  end

  describe '#invoke' do
    context 'when workspace exists' do
      before do
        workspace_entity = Domain::Entity::WorkSpace::WorkSpaceEntity.build_with_id(
          id: workspace_id, name: 'Old Name', slug: 'old-slug'
        )
        allow(work_space_repo).to receive(:get_by_id).with(id: workspace_id).and_return(workspace_entity)
        allow(work_space_service).to receive(:exists_by_slug?).and_return(false)
        allow(work_space_repo).to receive(:update).and_return(workspace_entity)
      end

      it 'returns updated WorkSpaceDto' do
        result = use_case.invoke(args: input_dto)
        expect(result.name).to eq('Updated WorkSpace')
      end
    end

    context 'when workspace does not exist' do
      before do
        allow(work_space_repo).to receive(:get_by_id).with(id: workspace_id).and_return(nil)
      end

      it 'raises NotFoundException' do
        expect { use_case.invoke(args: input_dto) }
          .to raise_error(Application::Exception::NotFoundException, 'workspace not found')
      end
    end

    context 'when new slug already exists' do
      before do
        workspace_entity = Domain::Entity::WorkSpace::WorkSpaceEntity.build_with_id(
          id: workspace_id, name: 'Old Name', slug: 'old-slug'
        )
        allow(work_space_repo).to receive(:get_by_id).with(id: workspace_id).and_return(workspace_entity)
        allow(work_space_service).to receive(:exists_by_slug?).and_return(true)
      end

      it 'raises DuplicatedException' do
        expect { use_case.invoke(args: input_dto) }
          .to raise_error(Application::Exception::DuplicatedException, 'workspace already exists')
      end
    end

    context 'when slug remains the same' do
      before do
        workspace_entity = Domain::Entity::WorkSpace::WorkSpaceEntity.build_with_id(
          id: workspace_id, name: 'Old Name', slug: 'old-slug'
        )
        input = Application::Dto::WorkSpace::UpdateWorkSpaceInputDto.new(
          id: workspace_id, name: 'New Name', slug: 'old-slug'
        )
        allow(work_space_repo).to receive(:get_by_id).with(id: workspace_id).and_return(workspace_entity)
        allow(work_space_repo).to receive(:update).and_return(workspace_entity)
        allow(work_space_service).to receive(:exists_by_slug?)
        use_case.invoke(args: input)
      end

      it 'does not check slug uniqueness' do
        expect(work_space_service).not_to have_received(:exists_by_slug?)
      end
    end
  end
end
