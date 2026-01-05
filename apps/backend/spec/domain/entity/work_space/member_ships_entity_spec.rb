# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::Entity::WorkSpace::MemberShipsEntity do
  let(:id) { Domain::ValueObject::IdentityId.build(SecureRandom.uuid) }
  let(:user_id) { Domain::ValueObject::IdentityId.build(SecureRandom.uuid) }
  let(:work_space_id) { Domain::ValueObject::IdentityId.build(SecureRandom.uuid) }
  let(:role) { Domain::ValueObject::WorkSpace::Role.build('owner') }
  let(:status) { Domain::ValueObject::WorkSpace::Status.build('active') }

  describe '#initialize' do
    it 'sets attributes' do
      entity = described_class.new(
        id: id,
        user_id: user_id,
        work_space_id: work_space_id,
        role: role,
        status: status
      )
      expect(entity.id).to eq(id)
      expect(entity.user_id).to eq(user_id)
      expect(entity.work_space_id).to eq(work_space_id)
      expect(entity.role).to eq(role)
      expect(entity.status).to eq(status)
    end
  end

  describe '.build' do
    let(:user_id_str) { SecureRandom.uuid }
    let(:work_space_id_str) { SecureRandom.uuid }

    it 'returns a new entity with default role and status' do
      entity = described_class.build(user_id: user_id_str, work_space_id: work_space_id_str)
      expect(entity.user_id.value).to eq(user_id_str)
      expect(entity.work_space_id.value).to eq(work_space_id_str)
      expect(entity.role.value).to eq('owner')
      expect(entity.status.value).to eq('active')
    end

    it 'returns a new entity with specified role and status' do
      entity = described_class.build(
        user_id: user_id_str,
        work_space_id: work_space_id_str,
        role: 'admin',
        status: 'pending'
      )
      expect(entity.role.value).to eq('admin')
      expect(entity.status.value).to eq('pending')
    end
  end

  describe '.build_with_id' do
    let(:id_str) { SecureRandom.uuid }
    let(:user_id_str) { SecureRandom.uuid }
    let(:work_space_id_str) { SecureRandom.uuid }

    it 'returns a new entity with id' do
      entity = described_class.build_with_id(
        id: id_str,
        user_id: user_id_str,
        work_space_id: work_space_id_str,
        role: 'owner',
        status: 'active'
      )
      expect(entity.id.value).to eq(id_str)
      expect(entity.user_id.value).to eq(user_id_str)
      expect(entity.work_space_id.value).to eq(work_space_id_str)
    end
  end
end
