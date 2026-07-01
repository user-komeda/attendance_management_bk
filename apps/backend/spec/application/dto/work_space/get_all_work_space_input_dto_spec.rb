# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::WorkSpace::GetAllWorkSpaceInputDto do
  describe '.build' do
    subject(:dto) { described_class.build(page: 1, per_page: 10, search_query: 'test') }

    it 'returns a GetAllWorkSpaceInputDto' do
      expect(dto).to be_a(described_class)
    end

    it 'sets page' do
      expect(dto.page).to eq(1)
    end

    it 'sets per_page' do
      expect(dto.per_page).to eq(10)
    end

    it 'sets search_query' do
      expect(dto.search_query).to eq('test')
    end
  end

  describe '.build with nil search_query' do
    subject(:dto) { described_class.build(page: 2, per_page: 20, search_query: nil) }

    it 'sets search_query to nil' do
      expect(dto.search_query).to be_nil
    end
  end

  describe '#convert_to_entity' do
    subject(:dto) { described_class.build(page: 1, per_page: 10, search_query: nil) }

    it 'raises NotImplementedError' do
      expect { dto.convert_to_entity }.to raise_error(NotImplementedError)
    end
  end
end
