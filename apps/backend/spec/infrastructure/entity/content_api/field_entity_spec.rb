# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Entity::ContentApi::FieldEntity do
  let(:id) { SecureRandom.uuid }
  let(:content_api_id) { SecureRandom.uuid }
  let(:base_attrs) do
    {
      id: id,
      content_api_id: content_api_id,
      field_id: 'title',
      display_name: 'Title',
      field_type: 'text',
      required: false,
      unique_value: false,
      order_index: 0,
      is_active: true,
      settings: {}
    }
  end

  describe '#to_domain' do
    it 'returns a Domain::Entity::ContentApi::FieldEntity' do
      entity = described_class.new(**base_attrs)
      expect(entity.to_domain).to be_a(Domain::Entity::ContentApi::FieldEntity)
    end
  end

  describe '.struct_to_domain' do
    let(:struct) do
      double(
        id: SecureRandom.uuid,
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

    it 'returns a Domain::Entity::ContentApi::FieldEntity' do
      result = described_class.struct_to_domain(struct: struct)
      expect(result).to be_a(Domain::Entity::ContentApi::FieldEntity)
    end
  end

  describe '.build_from_domain_entity' do
    let(:domain_field_with_id) do
      Domain::Entity::ContentApi::FieldEntity.build_with_id(
        id: id,
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

    let(:domain_field_without_id) do
      Domain::Entity::ContentApi::FieldEntity.build(
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

    it 'uses existing id when field_entity has an id' do
      result = described_class.build_from_domain_entity(field_entity: domain_field_with_id,
                                                        content_api_id: content_api_id)
      expect(result.id).to eq(id)
    end

    it 'generates a new uuid when field_entity has no id' do
      result = described_class.build_from_domain_entity(field_entity: domain_field_without_id,
                                                        content_api_id: content_api_id)
      expect(result.id).to match(/\A[0-9a-f-]{36}\z/)
    end
  end
end
