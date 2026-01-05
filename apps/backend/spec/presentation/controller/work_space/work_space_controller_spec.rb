# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Controller::WorkSpace::WorkSpaceController do
  let(:controller) { described_class.new }
  let(:workspace_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }

  describe '#index' do
    let(:mock_use_case) { instance_double(Application::UseCase::WorkSpace::GetAllWorkSpaceUseCase) }
    let(:dto) do
      instance_double(
        Application::Dto::WorkSpace::WorkSpaceWithStatusDto,
        status: 'active',
        work_spaces: instance_double(
          Application::Dto::WorkSpace::WorkSpaceDto,
          id: workspace_id, name: 'Test', slug: 'test'
        )
      )
    end

    before do
      allow(controller).to receive(:resolve).and_return(mock_use_case)
      allow(mock_use_case).to receive(:invoke).and_return([dto])
    end

    it 'returns an array of responses' do
      result = controller.index
      expect(result).to be_an(Array)
      expect(result.first[:status]).to eq('active')
      expect(result.first[:id]).to eq(workspace_id)
      expect(result.first[:name]).to eq('Test')
    end
  end

  describe '#show' do
    let(:mock_use_case) { instance_double(Application::UseCase::WorkSpace::GetDetailWorkSpaceUseCase) }
    let(:dto) do
      instance_double(
        Application::Dto::WorkSpace::WorkSpaceWithMemberShipsDto,
        work_spaces: instance_double(Application::Dto::WorkSpace::WorkSpaceDto, id: workspace_id, name: 'Test',
                                                                                slug: 'test'),
        member_ships: instance_double(Application::Dto::WorkSpace::MemberShipsDto, id: 'ms1', user_id: user_id,
                                                                                   work_space_id: workspace_id, role: 'owner', status: 'active')
      )
    end

    before do
      allow(controller).to receive(:resolve).and_return(mock_use_case)
      allow(mock_use_case).to receive(:invoke).and_return(dto)
    end

    it 'returns workspace with memberships' do
      result = controller.show(workspace_id)
      expect(result[:id]).to eq(workspace_id)
      expect(result[:work_spaces][:name]).to eq('Test')
      expect(result[:member_ships][:role]).to eq('owner')
    end

    it 'raises ArgumentError with empty id' do
      expect { controller.show('') }.to raise_error(ArgumentError)
    end
  end

  describe '#create' do
    let(:mock_use_case) { instance_double(Application::UseCase::WorkSpace::CreateWorkSpaceUseCase) }
    let(:params) { { name: 'New WorkSpace', slug: 'new-workspace' } }
    let(:dto) do
      instance_double(
        Application::Dto::WorkSpace::WorkSpaceWithMemberShipsDto,
        work_spaces: instance_double(Application::Dto::WorkSpace::WorkSpaceDto, id: workspace_id,
                                                                                name: 'New WorkSpace', slug: 'new-workspace'),
        member_ships: instance_double(Application::Dto::WorkSpace::MemberShipsDto, id: 'ms1', user_id: user_id,
                                                                                   work_space_id: workspace_id, role: 'owner', status: 'active')
      )
    end

    before do
      allow(controller).to receive(:resolve).and_return(mock_use_case)
      allow(mock_use_case).to receive(:invoke).and_return(dto)
    end

    it 'creates a workspace' do
      result = controller.create(params)
      expect(result[:id]).to eq(workspace_id)
      expect(result[:work_spaces][:name]).to eq('New WorkSpace')
    end
  end

  describe '#update' do
    let(:mock_use_case) { instance_double(Application::UseCase::WorkSpace::UpdateWorkSpaceUseCase) }
    let(:params) { { name: 'Updated' } }
    let(:dto) { instance_double(Application::Dto::WorkSpace::WorkSpaceDto, id: workspace_id, name: 'Updated', slug: 'test') }

    before do
      allow(controller).to receive(:resolve).and_return(mock_use_case)
      allow(mock_use_case).to receive(:invoke).and_return(dto)
    end

    it 'updates a workspace' do
      result = controller.update(params, workspace_id)
      expect(result[:id]).to eq(workspace_id)
      expect(result[:name]).to eq('Updated')
    end
  end

  describe '#destroy' do
    let(:mock_use_case) { instance_double(Application::UseCase::WorkSpace::DeleteWorkSpaceUseCase) }

    before do
      allow(controller).to receive(:resolve).and_return(mock_use_case)
      allow(mock_use_case).to receive(:invoke)
    end

    it 'deletes a workspace' do
      controller.destroy(workspace_id)
      expect(mock_use_case).to have_received(:invoke).with(args: workspace_id)
    end

    it 'raises ArgumentError with empty id' do
      expect { controller.destroy('') }.to raise_error(ArgumentError)
    end
  end
end
