# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::WorkSpace::MemberShipsDto do
  let(:member_ships_entity) do
    Domain::Entity::WorkSpace::MemberShipsEntity.new(
      id: Domain::ValueObject::IdentityId.build(SecureRandom.uuid),
      user_id: Domain::ValueObject::IdentityId.build(SecureRandom.uuid),
      work_space_id: Domain::ValueObject::IdentityId.build(SecureRandom.uuid),
      role: Domain::ValueObject::WorkSpace::Role.build('owner'),
      status: Domain::ValueObject::WorkSpace::Status.build('active')
    )
  end

  describe '.build' do
    subject(:dto) { described_class.build(member_ships_entity) }

    it 'returns a MemberShipsDto' do
      expect(dto).to be_a(described_class)
    end

    it 'sets id' do
      expect(dto.id).to eq(member_ships_entity.id.value)
    end

    it 'sets user_id' do
      expect(dto.user_id).to eq(member_ships_entity.user_id.value)
    end

    it 'sets work_space_id' do
      expect(dto.work_space_id).to eq(member_ships_entity.work_space_id.value)
    end

    it 'sets role' do
      expect(dto.role).to eq(member_ships_entity.role.value)
    end

    it 'sets status' do
      expect(dto.status).to eq(member_ships_entity.status.value)
    end

    context 'when role is nil' do
      let(:member_ships_entity) do
        Domain::Entity::WorkSpace::MemberShipsEntity.new(
          id: Domain::ValueObject::IdentityId.build(SecureRandom.uuid),
          user_id: Domain::ValueObject::IdentityId.build(SecureRandom.uuid),
          work_space_id: Domain::ValueObject::IdentityId.build(SecureRandom.uuid),
          role: nil,
          status: Domain::ValueObject::WorkSpace::Status.build('active')
        )
      end

      it 'raises ArgumentError' do
        expect { dto }.to raise_error(ArgumentError, 'role and status must not be nil')
      end
    end

    context 'when status is nil' do
      let(:member_ships_entity) do
        Domain::Entity::WorkSpace::MemberShipsEntity.new(
          id: Domain::ValueObject::IdentityId.build(SecureRandom.uuid),
          user_id: Domain::ValueObject::IdentityId.build(SecureRandom.uuid),
          work_space_id: Domain::ValueObject::IdentityId.build(SecureRandom.uuid),
          role: Domain::ValueObject::WorkSpace::Role.build('owner'),
          status: nil
        )
      end

      it 'raises ArgumentError' do
        expect { dto }.to raise_error(ArgumentError, 'role and status must not be nil')
      end
    end
  end
end
