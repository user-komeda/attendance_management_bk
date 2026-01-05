# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::WorkSpace::UpdateWorkSpaceInputDto do
  let(:id) { SecureRandom.uuid }
  let(:name) { 'Updated WorkSpace' }
  let(:slug) { 'updated-workspace' }

  describe '#initialize' do
    subject(:dto) { described_class.new(id: id, name: name, slug: slug) }

    it 'assigns id' do
      expect(dto.id).to eq(id)
    end

    it 'assigns name' do
      expect(dto.name).to eq(name)
    end

    it 'assigns slug' do
      expect(dto.slug).to eq(slug)
    end
  end

  describe '#convert_to_entity' do
    subject(:entity) { described_class.new(id: id, name: name, slug: slug).convert_to_entity }

    it 'returns a WorkSpaceEntity' do
      expect(entity).to be_a(Domain::Entity::WorkSpace::WorkSpaceEntity)
    end

    it 'sets name' do
      expect(entity.name).to eq(name)
    end

    it 'sets slug' do
      expect(entity.slug).to eq(slug)
    end

    it 'does not set id' do
      expect(entity.id).to be_nil
    end
  end
end
