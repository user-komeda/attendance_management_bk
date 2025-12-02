# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Controller::ControllerPayLoad do
  describe '#initialize' do
    let(:data_hash) do
      {
        id: '00000000-0000-0000-0000-000000000001',
        first_name: 'Taro',
        last_name: 'Yamada',
        email: 'taro.yamada@example.com'
      }
    end

    let(:payload) do
      described_class.new(
        id: '00000000-0000-0000-0000-000000000001',
        status_code: 201,
        data: data_hash
      )
    end

    it 'sets id' do
      expect(payload.id).to eq('00000000-0000-0000-0000-000000000001')
    end

    it 'sets status_code' do
      expect(payload.status_code).to eq(201)
    end

    it 'sets data' do
      expect(payload.data).to eq(data_hash)
    end
  end

  describe 'defaults' do
    it 'uses default values when not provided' do
      payload = described_class.new
      expect(payload).to have_attributes(id: '', status_code: 200, data: [])
    end
  end
end
