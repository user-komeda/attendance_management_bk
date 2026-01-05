# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::WorkSpace::CreateWorkSpaceUseCase do
  subject(:use_case) { described_class.new }

  let(:input_dto) do
    Application::Dto::WorkSpace::CreateWorkSpaceInputDto.new(
      params: { name: 'Test WorkSpace', slug: 'test-workspace' }
    )
  end

  let(:user_id) { SecureRandom.uuid }
  let(:workspace_id) { SecureRandom.uuid }
  let(:membership_id) { SecureRandom.uuid }

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

  let(:work_space_repo) { instance_double(Domain::Repository::WorkSpace::WorkSpaceRepository) }
  let(:membership_repo) { instance_double(Domain::Repository::WorkSpace::MemberShipsRepository) }
  let(:work_space_service) { instance_double(Domain::Service::WorkSpace::WorkSpaceService) }
  let(:rom_gateway) { instance_double(ROM::Gateway) }
  let(:rom_config) { instance_double(ROM::Configuration, gateways: { default: rom_gateway }) }

  before do
    allow(ContextHelper).to receive(:get_context).with(:auth_context).and_return({ user_id: user_id })
    allow(rom_gateway).to receive(:transaction).and_yield

    # rubocop:disable RSpec/SubjectStub
    allow(use_case).to receive(:resolve) do |key|
      case key
      when described_class::WORK_SPACE_REPOSITORY
        work_space_repo
      when described_class::MEMBER_SHIPS_REPOSITORY
        membership_repo
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
    context 'when workspace does not exist' do
      before do
        allow(work_space_service).to receive(:exists_by_slug?).with(slug: 'test-workspace').and_return(false)
        allow(work_space_repo).to receive(:create).and_return(workspace_entity)
        allow(membership_repo).to receive(:create).and_return(membership_entity)
      end

      it 'returns WorkSpaceWithMemberShipsDto' do
        result = use_case.invoke(args: input_dto)
        expect(result).to be_a(Application::Dto::WorkSpace::WorkSpaceWithMemberShipsDto)
        expect(result.work_spaces.id).to eq(workspace_id)
        expect(result.member_ships.id).to eq(membership_id)
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
