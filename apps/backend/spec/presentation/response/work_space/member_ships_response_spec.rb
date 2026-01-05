# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Response::WorkSpace::MemberShipsResponse do
  let(:id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:workspace_id) { SecureRandom.uuid }
  let(:dto) do
    instance_double(
      Application::Dto::WorkSpace::MemberShipsDto,
      id: id,
      user_id: user_id,
      work_space_id: workspace_id,
      role: 'owner',
      status: 'active'
    )
  end

  describe '.build' do
    it 'returns a hash representation' do
      result = described_class.build(member_ships: dto)
      expect(result).to eq({
                             id: id,
                             user_id: user_id,
                             work_space_id: workspace_id,
                             role: 'owner',
                             status: 'active'
                           })
    end
  end
end
