# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Repository::Rom::ContentApi::ContentApiRomRepository do
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

      def to_a
        rows
      end

      def by_work_space_id(_id)
        self
      end

      def by_content_api_id(_id)
        self
      end
    end
  end

  let(:content_api_id) { SecureRandom.uuid }
  let(:work_space_id) { SecureRandom.uuid }
  let(:repo) { create_repo_instance }

  def infra_entity
    Infrastructure::Entity::ContentApi::ContentApiEntity.new(
      id: content_api_id,
      work_space_id: work_space_id,
      name: 'Articles',
      endpoint: 'articles',
      api_type: 'list'
    )
  end

  def field_infra_entity
    Infrastructure::Entity::ContentApi::FieldEntity.new(
      id: SecureRandom.uuid,
      content_api_id: content_api_id,
      field_id: 'title',
      display_name: 'Title',
      field_type: 'text',
      required: false,
      unique_value: false,
      order_index: 0,
      is_active: true,
      settings: {}
    )
  end

  def create_repo_instance
    mock_container = instance_double(Object)
    repo = described_class.allocate
    repo.instance_variable_set(:@container, mock_container)
    repo.send(:initialize, container: mock_container)
    repo
  end

  describe '#get_by_work_space_id' do
    def fake_content_apis
      fake_relation_class.new([infra_entity])
    end

    before do
      allow(repo).to receive(:content_apis).and_return(fake_content_apis)
      allow(infra_entity).to receive(:to_domain).and_return(instance_double(Domain::Entity::ContentApi::ContentApiEntity))
    end

    it 'returns an array of domain entities' do
      result = repo.get_by_work_space_id(work_space_id: work_space_id)
      expect(result.length).to eq(1)
    end

    it 'maps to ContentApiEntity' do
      repo.get_by_work_space_id(work_space_id: work_space_id)
      expect(fake_content_apis.mapped_class).to eq(Infrastructure::Entity::ContentApi::ContentApiEntity)
    end
  end

  describe '#get_by_content_api_id' do
    def fake_fields
      fake_relation_class.new([field_infra_entity])
    end

    before do
      allow(repo).to receive(:fields).and_return(fake_fields)
    end

    it 'returns an array of field infra entities' do
      result = repo.get_by_content_api_id(content_api_id)
      expect(result).to eq([field_infra_entity])
    end

    it 'maps to FieldEntity' do
      repo.get_by_content_api_id(content_api_id)
      expect(fake_fields.mapped_class).to eq(Infrastructure::Entity::ContentApi::FieldEntity)
    end
  end
end
