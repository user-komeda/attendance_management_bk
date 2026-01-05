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
    it 'returns a domain entity' do
      allow(rom_repo).to receive(:get_by_user_id_and_work_space_id)
                           .with(user_id: user_id, work_space_id: workspace_id)
                           .and_return(nil)
      result = repository.get_by_user_id_and_work_space_id(user_id: user_id, work_space_id: workspace_id)
      expect(result).to be_nil
    end
  end

  describe 'Infrastructure::Entity::WorkSpace::MemberShipsEntity' do
    let(:domain_id) { Domain::ValueObject::IdentityId.build(membership_id) }
    let(:domain_user_id) { Domain::ValueObject::IdentityId.build(user_id) }
    let(:domain_workspace_id) { Domain::ValueObject::IdentityId.build(workspace_id) }
    let(:domain_role) { Domain::ValueObject::WorkSpace::Role.build('owner') }
    let(:domain_status) { Domain::ValueObject::WorkSpace::Status.build('active') }
    let(:domain_membership) do
      Domain::Entity::WorkSpace::MemberShipsEntity.new(
        id: domain_id,
        user_id: domain_user_id,
        work_space_id: domain_workspace_id,
        role: domain_role,
        status: domain_status
      )
    end

    it 'converts struct to domain' do
      struct = double('struct', id: membership_id, user_id: user_id, work_space_id: workspace_id, role: 'owner',
                                status: 'active')
      result = Infrastructure::Entity::WorkSpace::MemberShipsEntity.struct_to_domain(struct: struct)
      expect(result).to be_a(Domain::Entity::WorkSpace::MemberShipsEntity)
      expect(result.id.value).to eq(membership_id)
    end

    it 'builds from domain entity' do
      result = Infrastructure::Entity::WorkSpace::MemberShipsEntity.build_from_domain_entity(member_ships_entity: domain_membership)
      expect(result).to be_a(Infrastructure::Entity::WorkSpace::MemberShipsEntity)
      expect(result.id).to eq(membership_id)
    end

    it 'generates uuid when domain id is empty' do
      empty_id_domain = double('domain_membership',
                               id: nil,
                               user_id: domain_user_id,
                               work_space_id: domain_workspace_id,
                               role: domain_role,
                               status: domain_status)
      result = Infrastructure::Entity::WorkSpace::MemberShipsEntity.build_from_domain_entity(member_ships_entity: empty_id_domain)
      expect(result.id).not_to be_empty
      expect(result.id).not_to eq('')
    end

    it 'sets default role when role is empty' do
      empty_role_domain = double('domain_membership',
                                 id: domain_id,
                                 user_id: domain_user_id,
                                 work_space_id: domain_workspace_id,
                                 role: nil,
                                 status: domain_status)
      result = Infrastructure::Entity::WorkSpace::MemberShipsEntity.build_from_domain_entity(member_ships_entity: empty_role_domain)
      expect(result.role).to eq('owner')
    end

    it 'sets default status when status is empty' do
      empty_status_domain = double('domain_membership',
                                   id: domain_id,
                                   user_id: domain_user_id,
                                   work_space_id: domain_workspace_id,
                                   role: domain_role,
                                   status: nil)
      result = Infrastructure::Entity::WorkSpace::MemberShipsEntity.build_from_domain_entity(member_ships_entity: empty_status_domain)
      expect(result.status).to eq('active')
    end
  end
end
