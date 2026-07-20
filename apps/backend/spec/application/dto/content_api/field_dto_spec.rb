# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::ContentApi::FieldDto do
  let(:content_api_id) { SecureRandom.uuid }
  let(:field_params) do
    {
      content_api_id: content_api_id,
      field_id: 'title',
      display_name: 'Title',
      field_type: 'text',
      required: true,
      unique_value: false,
      order_index: 0,
      is_active: true,
      settings: {}
    }
  end

  describe '.build' do
    context 'when field entity has an id' do
      subject(:dto) { described_class.build(field_entity_with_id) }

      let(:field_id) { SecureRandom.uuid }
      let(:field_entity_with_id) { Domain::Entity::ContentApi::FieldEntity.build_with_id(id: field_id, **field_params) }

      it 'sets id from entity' do
        expect(dto.id).to eq(field_id)
      end
    end

    context 'when field entity has no id' do
      subject(:dto) { described_class.build(Domain::Entity::ContentApi::FieldEntity.build(**field_params)) }

      it 'sets id to empty string' do
        expect(dto.id).to eq('')
      end
    end
  end
end
