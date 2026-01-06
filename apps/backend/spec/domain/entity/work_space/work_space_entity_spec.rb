# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::Entity::WorkSpace::WorkSpaceEntity do
  let(:name) { 'Test WorkSpace' }
  let(:slug) { 'test-workspace' }
  let(:id) { Domain::ValueObject::IdentityId.build(SecureRandom.uuid) }

  describe '#initialize' do
    subject(:entity) { described_class.new(name: name, slug: slug, id: id) }

    it 'sets attributes' do
      aggregate_failures do
        expect(entity.name).to eq(name)
        expect(entity.slug).to eq(slug)
        expect(entity.id).to eq(id)
      end
    end
  end

  describe '#change' do
    let(:entity) { described_class.new(name: name, slug: slug) }

    it 'updates name' do
      entity.change(change_name: 'New Name', change_slug: nil)
      aggregate_failures do
        expect(entity.name).to eq('New Name')
        expect(entity.slug).to eq(slug)
      end
    end

    it 'updates slug' do
      entity.change(change_name: nil, change_slug: 'new-slug')
      aggregate_failures do
        expect(entity.name).to eq(name)
        expect(entity.slug).to eq('new-slug')
      end
    end

    it 'updates both' do
      entity.change(change_name: 'New Name', change_slug: 'new-slug')
      aggregate_failures do
        expect(entity.name).to eq('New Name')
        expect(entity.slug).to eq('new-slug')
      end
    end

    it 'does nothing if both are nil' do
      entity.change(change_name: nil, change_slug: nil)
      aggregate_failures do
        expect(entity.name).to eq(name)
        expect(entity.slug).to eq(slug)
      end
    end
  end

  describe '.build' do
    subject(:entity) { described_class.build(name: name, slug: slug) }

    it 'returns a new entity without id' do
      aggregate_failures do
        expect(entity.name).to eq(name)
        expect(entity.slug).to eq(slug)
        expect(entity.id).to be_nil
      end
    end
  end

  describe '.build_with_id' do
    subject(:entity) { described_class.build_with_id(id: id_str, name: name, slug: slug) }

    let(:id_str) { SecureRandom.uuid }

    it 'returns a new entity with id' do
      aggregate_failures do
        expect(entity.name).to eq(name)
        expect(entity.slug).to eq(slug)
        expect(entity.id.value).to eq(id_str)
      end
    end
  end
end
