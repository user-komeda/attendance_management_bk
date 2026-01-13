# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Request::WorkSpace::UpdateWorkSpaceRequest do
  let(:id) { SecureRandom.uuid }
  let(:params) { { id: id, name: 'Updated WorkSpace', slug: 'updated-workspace' } }

  describe '.build' do
    it 'returns an UpdateWorkSpaceRequest with valid params' do
      expect(described_class.build(params: params)).to be_a(described_class)
    end

    it 'raises BadRequestException with invalid params' do
      expect { described_class.build(params: { id: 'invalid' }) }.to raise_error(Presentation::Exception::BadRequestException)
    end
  end

  describe '#convert_to_dto' do
    subject(:dto) { request.convert_to_dto }

    let(:request) { described_class.new(params: params) }

    it 'returns an UpdateWorkSpaceInputDto' do
      expect(dto).to be_a(Application::Dto::WorkSpace::UpdateWorkSpaceInputDto)
    end

    it 'sets id correctly' do
      expect(dto.id).to eq(id)
    end

    it 'sets name correctly' do
      expect(dto.name).to eq('Updated WorkSpace')
    end

    it 'sets slug correctly' do
      expect(dto.slug).to eq('updated-workspace')
    end
  end
end
