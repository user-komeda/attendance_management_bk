# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::WorkSpace::WorkSpaceDto do
  let(:id) { SecureRandom.uuid }
  let(:name) { 'Test WorkSpace' }
  let(:slug) { 'test-workspace' }
  let(:work_space_entity) do
    Domain::Entity::WorkSpace::WorkSpaceEntity.new(
      id: Domain::ValueObject::IdentityId.build(id),
      name: name,
      slug: slug
    )
  end

  describe '.build' do
    subject(:dto) { described_class.build(work_space_entity: work_space_entity) }

    it 'returns a WorkSpaceDto' do
      expect(dto).to be_a(described_class)
    end

    it 'sets id' do
      expect(dto.id).to eq(id)
    end

    it 'sets name' do
      expect(dto.name).to eq(name)
    end

    it 'sets slug' do
      expect(dto.slug).to eq(slug)
    end
  end

  describe '.build_from_array' do
    subject(:dtos) { described_class.build_from_array(work_space_list: work_space_list) }

    let(:work_space_list) { [work_space_entity] }


    it 'returns an array of WorkSpaceDto' do
      expect(dtos).to all(be_a(described_class))
    end

    it 'has correct size' do
      expect(dtos.size).to eq(1)
    end

    it 'sets correct values for the first element' do
      expect(dtos.first.id).to eq(id)
      expect(dtos.first.name).to eq(name)
      expect(dtos.first.slug).to eq(slug)
    end
  end
end
