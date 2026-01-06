# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::Repository::WorkSpace::MemberShipsRepository do
  subject(:repository) do
    repo = described_class.allocate
    allow(repo).to receive(:resolve).with(described_class::REPOSITORY_KEY).and_return(infra_repo)
    repo
  end

  let(:dependencies) { { described_class::REPOSITORY_KEY => infra_repo } }
  let(:infra_repo) { instance_double(Infrastructure::Repository::WorkSpace::MemberShipsRepository) }
  let(:membership_entity) do
    instance_double(
      Domain::Entity::WorkSpace::MemberShipsEntity,
      id: instance_double(Domain::ValueObject::IdentityId, value: SecureRandom.uuid)
    )
  end
  let(:user_id) { SecureRandom.uuid }
  let(:workspace_id) { SecureRandom.uuid }

  describe '#work_space_ids_via_membership_by_user_id' do
    it 'delegates to infra repository' do
      allow(infra_repo).to receive(:work_space_ids_via_membership_by_user_id)
        .with(user_id: user_id)
        .and_return([[workspace_id, 'active']])
      expect(repository.work_space_ids_via_membership_by_user_id(user_id: user_id)).to eq([[workspace_id, 'active']])
    end
  end

  describe '#create' do
    it 'delegates to infra repository' do
      allow(infra_repo).to receive(:create).with(member_ships_entity: membership_entity).and_return(membership_entity)
      expect(repository.create(member_ships_entity: membership_entity)).to eq(membership_entity)
    end
  end

  describe '#get_by_user_id_and_work_space_id' do
    it 'delegates to infra repository' do
      allow(infra_repo).to receive(:get_by_user_id_and_work_space_id)
        .with(user_id: user_id, work_space_id: workspace_id)
        .and_return(membership_entity)
      expect(repository.get_by_user_id_and_work_space_id(user_id: user_id, work_space_id: workspace_id))
        .to eq(membership_entity)
    end
  end
end
