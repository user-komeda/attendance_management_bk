# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::Entity::WorkSpace::WorkSpaceEntity do
  let(:name) { 'Test WorkSpace' }
  let(:slug) { 'test-workspace' }
  let(:id) { Domain::ValueObject::IdentityId.build(SecureRandom.uuid) }

  describe '#initialize' do
    it 'sets attributes' do
      entity = described_class.new(name: name, slug: slug, id: id)
      expect(entity.name).to eq(name)
      expect(entity.slug).to eq(slug)
      expect(entity.id).to eq(id)
    end
  end

  describe '#change' do
    let(:entity) { described_class.new(name: name, slug: slug) }

    it 'updates name' do
      entity.change(change_name: 'New Name', change_slug: nil)
      expect(entity.name).to eq('New Name')
      expect(entity.slug).to eq(slug)
    end

    it 'updates slug' do
      entity.change(change_name: nil, change_slug: 'new-slug')
      expect(entity.name).to eq(name)
      expect(entity.slug).to eq('new-slug')
    end

    it 'updates both' do
      entity.change(change_name: 'New Name', change_slug: 'new-slug')
      expect(entity.name).to eq('New Name')
      expect(entity.slug).to eq('new-slug')
    end

    it 'does nothing if both are nil' do
      entity.change(change_name: nil, change_slug: nil)
      expect(entity.name).to eq(name)
      expect(entity.slug).to eq(slug)
    end
  end

  describe '.build' do
    it 'returns a new entity without id' do
      entity = described_class.build(name: name, slug: slug)
      expect(entity.name).to eq(name)
      expect(entity.slug).to eq(slug)
      expect(entity.id).to be_nil
    end
  end

  describe '.build_with_id' do
    let(:id_str) { SecureRandom.uuid }

    it 'returns a new entity with id' do
      entity = described_class.build_with_id(id: id_str, name: name, slug: slug)
      expect(entity.name).to eq(name)
      expect(entity.slug).to eq(slug)
      expect(entity.id.value).to eq(id_str)
    end
  end
end
