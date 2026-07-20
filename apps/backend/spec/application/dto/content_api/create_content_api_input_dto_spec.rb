# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::ContentApi::CreateContentApiInputDto do
  subject(:dto) { described_class.new(params: params) }

  let(:work_space_id) { SecureRandom.uuid }
  let(:override_work_space_id) { SecureRandom.uuid }
  let(:params) do
    {
      work_space_id: work_space_id,
      name: 'Articles',
      endpoint: 'articles',
      api_type: 'list'
    }
  end

  describe '#convert_to_entity' do
    it 'returns a ContentApiEntity' do
      entity = dto.convert_to_entity
      expect(entity).to be_a(Domain::Entity::ContentApi::ContentApiEntity)
    end

    it 'sets name correctly' do
      entity = dto.convert_to_entity
      expect(entity.name).to eq('Articles')
    end

    it 'sets endpoint correctly' do
      entity = dto.convert_to_entity
      expect(entity.endpoint).to eq('articles')
    end

    it 'sets api_type correctly' do
      entity = dto.convert_to_entity
      expect(entity.api_type).to eq('list')
    end
  end

  describe '#convert_to_entity_with_fields' do
    let(:field_entity) do
      Domain::Entity::ContentApi::FieldEntity.build(
        content_api_id: SecureRandom.uuid,
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

    it 'uses work_space_id from params when override_work_space_id is nil' do
      entity = dto.convert_to_entity_with_fields(fields: [field_entity])
      expect(entity.work_space_id.value).to eq(work_space_id)
    end

    it 'uses override_work_space_id when provided' do
      entity = dto.convert_to_entity_with_fields(fields: [field_entity], override_work_space_id: override_work_space_id)
      expect(entity.work_space_id.value).to eq(override_work_space_id)
    end

    it 'includes fields in entity' do
      entity = dto.convert_to_entity_with_fields(fields: [field_entity])
      expect(entity.fields.length).to eq(1)
    end
  end
end
