# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Response::WorkSpace::WorkSpaceWithMemberShipsResponse do
  let(:workspace_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:membership_id) { SecureRandom.uuid }

  let(:ws_dto) do
    instance_double(
      Application::Dto::WorkSpace::WorkSpaceDto,
      id: workspace_id,
      name: 'Test',
      slug: 'test'
    )
  end

  let(:ms_dto) do
    instance_double(
      Application::Dto::WorkSpace::MemberShipsDto,
      id: membership_id,
      user_id: user_id,
      work_space_id: workspace_id,
      role: 'owner',
      status: 'active'
    )
  end

  describe '.build' do
    subject(:result) do
      described_class.build(id: workspace_id, work_spaces: ws_dto, member_ships: ms_dto)
    end

    it 'returns a hash representation' do
      aggregate_failures do
        expect(result[:id]).to eq(workspace_id)
        expect(result[:work_spaces][:name]).to eq('Test')
        expect(result[:member_ships][:role]).to eq('owner')
      end
    end
  end
end
