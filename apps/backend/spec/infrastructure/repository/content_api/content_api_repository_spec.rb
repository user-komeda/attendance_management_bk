# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Repository::ContentApi::ContentApiRepository do
  let(:content_api_id) { SecureRandom.uuid }
  let(:work_space_id) { SecureRandom.uuid }
  let(:rom_repo) { instance_double(Infrastructure::Repository::Rom::ContentApi::ContentApiRomRepository) }

  let(:repository) do
    described_class.new.tap do |repo|
      allow(repo).to receive(:resolve).with(described_class::ROM_REPOSITORY_KEY).and_return(rom_repo)
    end
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

  def infra_entity
    Infrastructure::Entity::ContentApi::ContentApiEntity.new(
      id: content_api_id,
      work_space_id: work_space_id,
      name: 'Articles',
      endpoint: 'articles',
      api_type: 'list'
    )
  end

  def domain_content_api_entity
    Domain::Entity::ContentApi::ContentApiEntity.build_with_id(
      id: content_api_id,
      work_space_id: work_space_id,
      name: 'Articles',
      endpoint: 'articles',
      api_type: 'list',
      fields: []
    )
  end

  describe '#find_by_id' do
    context 'when found' do
      def struct_with_fields
        instance_double(ROM::Struct, fields: [field_infra_entity]).tap do |s|
          allow(s).to receive_messages(
            id: content_api_id,
            work_space_id: work_space_id,
            name: 'Articles',
            endpoint: 'articles',
            api_type: 'list'
          )
        end
      end

      before do
        allow(rom_repo).to receive(:rom_get_by_id).with(id: content_api_id).and_return(struct_with_fields)
        allow(Infrastructure::Entity::ContentApi::ContentApiEntity)
          .to receive(:struct_to_domain_with_fields)
          .with(struct: struct_with_fields)
          .and_return(domain_content_api_entity)
      end

      it 'returns domain entity' do
        result = repository.find_by_id(id: content_api_id)
        expect(result).to be_a(Domain::Entity::ContentApi::ContentApiEntity)
      end
    end

    context 'when not found' do
      before do
        allow(rom_repo).to receive(:rom_get_by_id).with(id: content_api_id).and_return(nil)
      end

      it 'returns nil' do
        expect(repository.find_by_id(id: content_api_id)).to be_nil
      end
    end
  end

  describe '#find_by_work_space_and_endpoint' do
    context 'when found' do
      before do
        allow(rom_repo)
          .to receive(:rom_find_by_work_space_and_endpoint)
          .with(work_space_id: work_space_id, endpoint: 'articles')
          .and_return(infra_entity)
        allow(Infrastructure::Entity::ContentApi::ContentApiEntity)
          .to receive(:struct_to_domain)
          .with(struct: infra_entity)
          .and_return(domain_content_api_entity)
      end

      it 'returns domain entity' do
        result = repository.find_by_work_space_and_endpoint(work_space_id: work_space_id, endpoint: 'articles')
        expect(result).to be_a(Domain::Entity::ContentApi::ContentApiEntity)
      end
    end

    context 'when not found' do
      before do
        allow(rom_repo)
          .to receive(:rom_find_by_work_space_and_endpoint)
          .with(work_space_id: work_space_id, endpoint: 'articles')
          .and_return(nil)
      end

      it 'returns nil' do
        expect(repository.find_by_work_space_and_endpoint(work_space_id: work_space_id, endpoint: 'articles')).to be_nil
      end
    end
  end

  describe '#delete_by_id' do
    before do
      allow(rom_repo).to receive(:rom_delete_fields_by_content_api_id).with(content_api_id: content_api_id)
      allow(rom_repo).to receive(:rom_delete).with(id: content_api_id)
    end

    it 'deletes fields by content_api id' do
      repository.delete_by_id(id: content_api_id)
      expect(rom_repo).to have_received(:rom_delete_fields_by_content_api_id).with(content_api_id: content_api_id)
    end

    it 'deletes content_api' do
      repository.delete_by_id(id: content_api_id)
      expect(rom_repo).to have_received(:rom_delete).with(id: content_api_id)
    end
  end
end
