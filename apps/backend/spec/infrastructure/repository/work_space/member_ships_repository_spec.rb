# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Repository::WorkSpace::MemberShipsRepository do
  let(:repository) do
    described_class.new.tap do |repo|
      allow(repo).to receive(:resolve).with(described_class::ROM_REPOSITORY_KEY).and_return(rom_repo)
    end
  end

  let(:user_id) { SecureRandom.uuid }
  let(:workspace_id) { SecureRandom.uuid }
  let(:rom_repo) { instance_double(Infrastructure::Repository::Rom::WorkSpace::MemberShipsRomRepository) }

  def infra_entity
    Infrastructure::Entity::WorkSpace::MemberShipsEntity.new(
      id: SecureRandom.uuid, user_id: user_id, work_space_id: workspace_id, role: 'owner', status: 'active'
    )
  end

  def domain_entity
    infra_entity.to_domain
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
    let(:domain_ent) { domain_entity }

    it 'returns a domain entity' do
      infra_ent = Infrastructure::Entity::WorkSpace::MemberShipsEntity
                  .build_from_domain_entity(member_ships_entity: domain_ent)
      allow(rom_repo).to receive(:rom_create).with(kind_of(Infrastructure::Entity::WorkSpace::MemberShipsEntity))
                                             .and_return(infra_ent)
      expect(repository.create(member_ships_entity: domain_ent).id.value).to eq(domain_ent.id.value)
    end
  end

  describe '#get_by_user_id_and_work_space_id' do
    let(:infra_ent) { infra_entity }

    it 'returns a domain entity' do
      allow(rom_repo).to receive(:get_by_user_id_and_work_space_id)
        .with(user_id: user_id, work_space_id: workspace_id).and_return(infra_ent)
      result = repository.get_by_user_id_and_work_space_id(user_id: user_id, work_space_id: workspace_id)
      expect(result.id.value).to eq(infra_ent.id)
    end

    it 'returns nil if not found' do
      allow(rom_repo).to receive(:get_by_user_id_and_work_space_id)
        .with(user_id: user_id, work_space_id: workspace_id)
        .and_return(nil)
      result = repository.get_by_user_id_and_work_space_id(user_id: user_id, work_space_id: workspace_id)
      expect(result).to be_nil
    end
  end

  describe 'Infrastructure::Entity::WorkSpace::MemberShipsEntity' do
    let(:membership_id) { SecureRandom.uuid }

    def domain_membership
      Domain::Entity::WorkSpace::MemberShipsEntity.new(
        id: Domain::ValueObject::IdentityId.build(membership_id),
        user_id: Domain::ValueObject::IdentityId.build(SecureRandom.uuid),
        work_space_id: Domain::ValueObject::IdentityId.build(SecureRandom.uuid),
        role: Domain::ValueObject::WorkSpace::Role.build('owner'),
        status: Domain::ValueObject::WorkSpace::Status.build('active')
      )
    end

    def build_membership_double(overrides = {})
      user_id = SecureRandom.uuid
      workspace_id = SecureRandom.uuid
      membership_id = SecureRandom.uuid
      defaults = {
        id: Domain::ValueObject::IdentityId.build(membership_id),
        user_id: Domain::ValueObject::IdentityId.build(user_id),
        work_space_id: Domain::ValueObject::IdentityId.build(workspace_id),
        role: Domain::ValueObject::WorkSpace::Role.build('owner'),
        status: Domain::ValueObject::WorkSpace::Status.build('active')
      }
      instance_double(Domain::Entity::WorkSpace::MemberShipsEntity, defaults.merge(overrides))
    end

    it 'converts struct to domain' do
      struct = Struct.new(:id, :user_id, :work_space_id, :role, :status)
                     .new(membership_id, SecureRandom.uuid, SecureRandom.uuid, 'owner', 'active')
      result = Infrastructure::Entity::WorkSpace::MemberShipsEntity.struct_to_domain(struct: struct)
      expect(result.id.value).to eq(membership_id)
    end

    it 'builds from domain entity' do
      res = Infrastructure::Entity::WorkSpace::MemberShipsEntity.build_from_domain_entity(
        member_ships_entity: domain_membership
      )
      expect(res.id).to eq(membership_id)
    end

    it 'generates uuid when domain id is empty' do
      empty_id_domain = build_membership_double(id: nil)
      result = Infrastructure::Entity::WorkSpace::MemberShipsEntity.build_from_domain_entity(
        member_ships_entity: empty_id_domain
      )
      expect(result.id).not_to be_empty
    end

    it 'sets default role when role is empty' do
      empty_role_domain = build_membership_double(role: nil)
      result = Infrastructure::Entity::WorkSpace::MemberShipsEntity.build_from_domain_entity(
        member_ships_entity: empty_role_domain
      )
      expect(result.role).to eq('owner')
    end

    it 'sets default status when status is empty' do
      empty_status_domain = build_membership_double(status: nil)
      result = Infrastructure::Entity::WorkSpace::MemberShipsEntity.build_from_domain_entity(
        member_ships_entity: empty_status_domain
      )
      expect(result.status).to eq('active')
    end
  end
end
