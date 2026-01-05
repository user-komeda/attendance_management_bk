# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::WorkSpace::MemberShipsDto do
  let(:id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:work_space_id) { SecureRandom.uuid }
  let(:role) { 'owner' }
  let(:status) { 'active' }

  let(:member_ships_entity) do
    Domain::Entity::WorkSpace::MemberShipsEntity.new(
      id: Domain::ValueObject::IdentityId.build(id),
      user_id: Domain::ValueObject::IdentityId.build(user_id),
      work_space_id: Domain::ValueObject::IdentityId.build(work_space_id),
      role: Domain::ValueObject::WorkSpace::Role.build(role),
      status: Domain::ValueObject::WorkSpace::Status.build(status)
    )
  end

  describe '.build' do
    subject(:dto) { described_class.build(member_ships_entity) }

    it 'returns a MemberShipsDto' do
      expect(dto).to be_a(described_class)
    end

    it 'sets id' do
      expect(dto.id).to eq(id)
    end

    it 'sets user_id' do
      expect(dto.user_id).to eq(user_id)
    end

    it 'sets work_space_id' do
      expect(dto.work_space_id).to eq(work_space_id)
    end

    it 'sets role' do
      expect(dto.role).to eq(role)
    end

    it 'sets status' do
      expect(dto.status).to eq(status)
    end

    context 'when role is nil' do
      let(:role) { nil }
      let(:member_ships_entity) do
        Domain::Entity::WorkSpace::MemberShipsEntity.new(
          id: Domain::ValueObject::IdentityId.build(id),
          user_id: Domain::ValueObject::IdentityId.build(user_id),
          work_space_id: Domain::ValueObject::IdentityId.build(work_space_id),
          role: nil,
          status: Domain::ValueObject::WorkSpace::Status.build(status)
        )
      end

      it 'raises ArgumentError' do
        expect { dto }.to raise_error(ArgumentError, 'role and status must not be nil')
      end
    end

    context 'when status is nil' do
      let(:status) { nil }
      let(:member_ships_entity) do
        Domain::Entity::WorkSpace::MemberShipsEntity.new(
          id: Domain::ValueObject::IdentityId.build(id),
          user_id: Domain::ValueObject::IdentityId.build(user_id),
          work_space_id: Domain::ValueObject::IdentityId.build(work_space_id),
          role: Domain::ValueObject::WorkSpace::Role.build(role),
          status: nil
        )
      end

      it 'raises ArgumentError' do
        expect { dto }.to raise_error(ArgumentError, 'role and status must not be nil')
      end
    end
  end
end
