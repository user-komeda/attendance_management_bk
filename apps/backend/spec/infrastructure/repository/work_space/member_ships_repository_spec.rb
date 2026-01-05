# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Repository::WorkSpace::MemberShipsRepository do
  subject(:repository) { described_class.new }

  let(:rom_repo) { instance_double(Infrastructure::Repository::Rom::WorkSpace::MemberShipsRomRepository) }
  let(:user_id) { SecureRandom.uuid }
  let(:workspace_id) { SecureRandom.uuid }
  let(:membership_id) { SecureRandom.uuid }
  let(:infra_entity) do
    Infrastructure::Entity::WorkSpace::MemberShipsEntity.new(
      id: membership_id,
      user_id: user_id,
      work_space_id: workspace_id,
      role: 'owner',
      status: 'active'
    )
  end
  let(:domain_entity) { infra_entity.to_domain }

  before do
    # rubocop:disable RSpec/SubjectStub
    allow(repository).to receive(:resolve).with(described_class::ROM_REPOSITORY_KEY).and_return(rom_repo)
    # rubocop:enable RSpec/SubjectStub
  end

  describe '#work_space_ids_via_membership_by_user_id' do
    it 'delegates to rom repository' do
      allow(rom_repo).to receive(:work_space_ids_via_membership_by_user_id)
        .with(user_id: user_id)
        .and_return([[workspace_id, 'active']])
      expect(repository.work_space_ids_via_membership_by_user_id(user_id: user_id)).to eq([[workspace_id, 'active']])
    end
  end

  describe '#create' do
    it 'creates and returns a domain entity' do
      allow(rom_repo).to receive(:rom_create).and_return(infra_entity)
      result = repository.create(member_ships_entity: domain_entity)
      expect(result).to be_a(Domain::Entity::WorkSpace::MemberShipsEntity)
      expect(result.id.value).to eq(membership_id)
    end
  end

  describe '#get_by_user_id_and_work_space_id' do
    it 'returns a domain entity' do
      allow(rom_repo).to receive(:get_by_user_id_and_work_space_id)
        .with(user_id: user_id, work_space_id: workspace_id)
        .and_return(infra_entity)
      result = repository.get_by_user_id_and_work_space_id(user_id: user_id, work_space_id: workspace_id)
      expect(result).to be_a(Domain::Entity::WorkSpace::MemberShipsEntity)
      expect(result.id.value).to eq(membership_id)
    end
  end
end
