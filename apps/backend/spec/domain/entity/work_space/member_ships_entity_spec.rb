# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::Entity::WorkSpace::MemberShipsEntity do
  let(:id) { Domain::ValueObject::IdentityId.build(SecureRandom.uuid) }
  let(:attributes) do
    { id: id,
      user_id: Domain::ValueObject::IdentityId.build(SecureRandom.uuid),
      work_space_id: Domain::ValueObject::IdentityId.build(SecureRandom.uuid),
      role: Domain::ValueObject::WorkSpace::Role.build('owner'),
      status: Domain::ValueObject::WorkSpace::Status.build('active') }
  end

  describe '#initialize' do
    it 'sets attributes' do
      entity = described_class.new(**attributes)
      expect(entity).to have_attributes(attributes)
    end
  end

  describe '.build' do
    let(:user_id_str) { SecureRandom.uuid }
    let(:ws_id_str) { SecureRandom.uuid }

    context 'with default role and status' do
      subject(:entity) { described_class.build(user_id: user_id_str, work_space_id: ws_id_str) }

      it 'sets default values' do
        expect(entity).to have_attributes(
          role: have_attributes(value: 'owner'),
          status: have_attributes(value: 'active')
        )
      end
    end

    context 'with specified role and status' do
      subject(:entity) do
        described_class.build(
          user_id: user_id_str, work_space_id: ws_id_str, role: 'admin', status: 'pending'
        )
      end

      it 'sets specified values' do
        expect(entity).to have_attributes(
          role: have_attributes(value: 'admin'),
          status: have_attributes(value: 'pending')
        )
      end
    end
  end

  describe '.build_with_id' do
    let(:params) do
      { id: SecureRandom.uuid, user_id: SecureRandom.uuid, work_space_id: SecureRandom.uuid,
        role: 'owner', status: 'active' }
    end

    it 'returns a new entity with expected attributes' do
      entity = described_class.build_with_id(**params)
      expect(entity).to have_attributes(id: kind_of(Domain::ValueObject::IdentityId))
    end
  end
end
