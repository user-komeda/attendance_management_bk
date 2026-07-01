# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::ContentApi::CreateFieldInputDto do
  let(:base_params) do
    {
      field_id: 'title',
      display_name: 'Title',
      field_type: 'text',
      required: true,
      unique_value: false,
      order_index: 0,
      is_active: true,
      settings: { max_length: 255 }
    }
  end

  describe '#convert_to_entity' do
    context 'when content_api_id is provided' do
      let(:content_api_id) { SecureRandom.uuid }
      let(:dto) { described_class.new(params: base_params) }

      it 'returns a FieldEntity' do
        entity = dto.convert_to_entity(content_api_id: content_api_id)
        expect(entity).to be_a(Domain::Entity::ContentApi::FieldEntity)
      end

      it 'sets content_api_id value correctly' do
        entity = dto.convert_to_entity(content_api_id: content_api_id)
        expect(entity.content_api_id.value).to eq(content_api_id)
      end
    end

    context 'when content_api_id is empty string' do
      let(:dto) { described_class.new(params: base_params) }

      it 'returns a FieldEntity using build_without_content_api_id' do
        entity = dto.convert_to_entity(content_api_id: '')
        expect(entity).to be_a(Domain::Entity::ContentApi::FieldEntity)
      end

      it 'keeps field_id correctly' do
        entity = dto.convert_to_entity(content_api_id: '')
        expect(entity.field_id).to eq('title')
      end
    end
  end

  describe 'default values' do
    it 'sets default required to false' do
      dto = described_class.new(params: { field_id: 'f', display_name: 'F', field_type: 'text' })
      expect(dto.required).to be(false)
    end

    it 'sets default unique_value to false' do
      dto = described_class.new(params: { field_id: 'f', display_name: 'F', field_type: 'text' })
      expect(dto.unique_value).to be(false)
    end

    it 'sets default order_index to 0' do
      dto = described_class.new(params: { field_id: 'f', display_name: 'F', field_type: 'text' })
      expect(dto.order_index).to eq(0)
    end

    it 'sets default is_active to true' do
      dto = described_class.new(params: { field_id: 'f', display_name: 'F', field_type: 'text' })
      expect(dto.is_active).to be(true)
    end

    it 'sets default settings to empty hash' do
      dto = described_class.new(params: { field_id: 'f', display_name: 'F', field_type: 'text' })
      expect(dto.settings).to eq({})
    end
  end
end
