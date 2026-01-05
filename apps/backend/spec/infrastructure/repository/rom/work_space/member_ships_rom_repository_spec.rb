# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Repository::Rom::WorkSpace::MemberShipsRomRepository do
  let(:fake_relation_class) do
    Class.new do
      attr_accessor :rows, :mapped_class

      def initialize(rows, mapped_class = nil)
        @rows = rows
        @mapped_class = mapped_class
      end

      def map_to(klass)
        self.mapped_class = klass
        self
      end

      def by_user_id(_user_id)
        self
      end

      def by_work_space_id(_workspace_id)
        self
      end

      def plunk_work_space_id_and_status
        self
      end

      def to_a
        rows
      end

      def one
        rows.first
      end
    end
  end
  let(:repo) { create_repo_instance }
  let(:user_id) { SecureRandom.uuid }
  let(:workspace_id) { SecureRandom.uuid }
  let(:infra_entity) { build_infra_entity(user_id: user_id, workspace_id: workspace_id) }

  def build_infra_entity(id: SecureRandom.uuid, user_id: SecureRandom.uuid, workspace_id: SecureRandom.uuid)
    Infrastructure::Entity::WorkSpace::MemberShipsEntity.new(
      id: id, user_id: user_id, work_space_id: workspace_id, role: 'owner', status: 'active'
    )
  end

  def create_repo_instance
    mock_container = instance_double(Object)
    repo = described_class.allocate
    repo.instance_variable_set(:@container, mock_container)
    repo.send(:initialize, container: mock_container)
    repo
  end


  describe '#work_space_ids_via_membership_by_user_id' do
    let(:fake_memberships) { fake_relation_class.new([[workspace_id, 'active']]) }

    before do
      allow(repo).to receive(:member_ships).and_return(fake_memberships)
    end

    it 'returns an array of workspace ids and statuses' do
      result = repo.work_space_ids_via_membership_by_user_id(user_id: user_id)
      expect(result).to eq([[workspace_id, 'active']])
    end
  end

  describe '#rom_create' do
    it 'delegates to command' do
      allow(repo).to receive(:create).with(infra_entity).and_return(infra_entity)
      expect(repo.rom_create(infra_entity)).to eq(infra_entity)
    end
  end

  describe '#get_by_user_id_and_work_space_id' do
    let(:fake_memberships) { fake_relation_class.new([infra_entity]) }

    before do
      allow(repo).to receive(:member_ships).and_return(fake_memberships)
    end

    it 'returns one infra entity' do
      result = repo.get_by_user_id_and_work_space_id(user_id: user_id, work_space_id: workspace_id)
      expect(result).to be_a(Infrastructure::Entity::WorkSpace::MemberShipsEntity)
      expect(result.user_id).to eq(user_id)
      expect(result.work_space_id).to eq(workspace_id)
    end
  end
end
