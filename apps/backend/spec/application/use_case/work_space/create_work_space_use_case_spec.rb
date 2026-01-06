# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::WorkSpace::CreateWorkSpaceUseCase do
  let(:use_case) do
    described_class.new.tap do |uc|
      allow(uc).to receive(:resolve).with(described_class::WORK_SPACE_REPOSITORY).and_return(work_space_repo)
      allow(uc).to receive(:resolve).with(described_class::MEMBER_SHIPS_REPOSITORY).and_return(membership_repo)
      allow(uc).to receive(:resolve).with(described_class::WORK_SPACE_SERVICE).and_return(work_space_service)
      allow(uc).to receive(:resolve).with('db.config').and_return(memoized_rom_config)
    end
  end

  let(:work_space_repo) { instance_double(Domain::Repository::WorkSpace::WorkSpaceRepository) }
  let(:membership_repo) { instance_double(Domain::Repository::WorkSpace::MemberShipsRepository) }
  let(:work_space_service) { instance_double(Domain::Service::WorkSpace::WorkSpaceService) }
  let(:memoized_rom_config) { instance_double(ROM::Configuration, gateways: { default: instance_double(ROM::Gateway) }) }

  before do
    allow(ContextHelper).to receive(:get_context).and_return({ user_id: SecureRandom.uuid })
    allow(memoized_rom_config.gateways[:default]).to receive(:transaction).and_yield
  end

  private

  def input_dto
    Application::Dto::WorkSpace::CreateWorkSpaceInputDto.new(
      params: { name: 'Test WorkSpace', slug: 'test-workspace' }
    )
  end

  private

  def rom_config
    instance_double(ROM::Configuration, gateways: { default: instance_double(ROM::Gateway) })
  end


  describe '#invoke' do
    context 'when workspace does not exist' do
      before do
        workspace_id = SecureRandom.uuid
        membership_id = SecureRandom.uuid
        workspace_entity = Domain::Entity::WorkSpace::WorkSpaceEntity.build_with_id(
          id: workspace_id, name: 'Test WorkSpace', slug: 'test-workspace'
        )
        membership_entity = Domain::Entity::WorkSpace::MemberShipsEntity.build_with_id(
          id: membership_id, user_id: SecureRandom.uuid, work_space_id: workspace_id, role: 'owner', status: 'active'
        )
        allow(work_space_service).to receive(:exists_by_slug?).and_return(false)
        allow(work_space_repo).to receive(:create).and_return(workspace_entity)
        allow(membership_repo).to receive(:create).and_return(membership_entity)
      end

      it 'returns WorkSpaceWithMemberShipsDto' do
        result = use_case.invoke(args: input_dto)
        expect(result.work_spaces.name).to eq('Test WorkSpace')
      end
    end

    context 'when workspace already exists' do
      before do
        allow(work_space_service).to receive(:exists_by_slug?).with(slug: 'test-workspace').and_return(true)
      end

      it 'raises DuplicatedException' do
        expect { use_case.invoke(args: input_dto) }
          .to raise_error(Application::Exception::DuplicatedException, 'workspace already exists')
      end
    end
  end
end
