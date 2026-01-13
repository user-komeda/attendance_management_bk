# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Request::WorkSpace::CreateWorkSpaceRequest do
  let(:params) { { name: 'Test WorkSpace', slug: 'test-workspace' } }

  describe '.build' do
    it 'returns a CreateWorkSpaceRequest with valid params' do
      expect(described_class.build(params: params)).to be_a(described_class)
    end

    it 'raises BadRequestException with invalid params' do
      expect { described_class.build(params: { name: '' }) }.to raise_error(Presentation::Exception::BadRequestException)
    end
  end

  describe '#convert_to_dto' do
    subject(:dto) { request.convert_to_dto }

    let(:request) { described_class.new(params: params) }

    it 'returns a CreateWorkSpaceInputDto' do
      expect(dto).to be_a(Application::Dto::WorkSpace::CreateWorkSpaceInputDto)
    end

    it 'sets name correctly' do
      expect(dto.name).to eq('Test WorkSpace')
    end

    it 'sets slug correctly' do
      expect(dto.slug).to eq('test-workspace')
    end
  end
end
