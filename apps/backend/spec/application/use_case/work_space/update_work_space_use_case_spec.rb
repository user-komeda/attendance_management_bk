# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::WorkSpace::UpdateWorkSpaceUseCase do
  subject(:use_case) { described_class.new }

  let(:workspace_id) { SecureRandom.uuid }
  let(:input_dto) do
    Application::Dto::WorkSpace::UpdateWorkSpaceInputDto.new(
      id: workspace_id,
      name: 'Updated WorkSpace',
      slug: 'updated-workspace'
    )
  end

  let(:workspace_entity) do
    Domain::Entity::WorkSpace::WorkSpaceEntity.build_with_id(
      id: workspace_id,
      name: 'Old Name',
      slug: 'old-slug'
    )
  end

  let(:work_space_repo) { instance_double(Domain::Repository::WorkSpace::WorkSpaceRepository) }
  let(:work_space_service) { instance_double(Domain::Service::WorkSpace::WorkSpaceService) }
  let(:rom_gateway) { instance_double(ROM::Gateway) }
  let(:rom_config) { instance_double(ROM::Configuration, gateways: { default: rom_gateway }) }

  before do
    allow(rom_gateway).to receive(:transaction).and_yield

    # rubocop:disable RSpec/SubjectStub
    allow(use_case).to receive(:resolve) do |key|
      case key
      when described_class::WORK_SPACE_REPOSITORY
        work_space_repo
      when described_class::WORK_SPACE_SERVICE
        work_space_service
      when 'db.config'
        rom_config
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
        allow(work_space_service).to receive(:exists_by_slug?).with(slug: 'updated-workspace').and_return(false)
        allow(work_space_repo).to receive(:update).and_return(workspace_entity)
      end

      it 'returns updated WorkSpaceDto' do
        result = use_case.invoke(args: input_dto)
        expect(result).to be_a(Application::Dto::WorkSpace::WorkSpaceDto)
        expect(result.name).to eq('Updated WorkSpace')
        expect(result.slug).to eq('updated-workspace')
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
        allow(work_space_repo).to receive(:get_by_id).with(id: workspace_id).and_return(workspace_entity)
        allow(work_space_service).to receive(:exists_by_slug?).with(slug: 'updated-workspace').and_return(true)
      end

      it 'raises DuplicatedException' do
        expect { use_case.invoke(args: input_dto) }
          .to raise_error(Application::Exception::DuplicatedException, 'workspace already exists')
      end
    end
  end
end
