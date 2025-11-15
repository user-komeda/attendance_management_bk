# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Controller::ControllerPayLoad do
  describe '#initialize' do
    it 'initializes and exposes values' do
      payload = described_class.new(id: '00000000-0000-0000-0000-000000000001', status_code: 201, data: { id: '00000000-0000-0000-0000-000000000001',
                                                                                                          first_name: 'Taro',
                                                                                                          last_name: 'Yamada',
                                                                                                          email: 'taro.yamada@example.com' })
      expect(payload.id).to eq('00000000-0000-0000-0000-000000000001')
      expect(payload.status_code).to eq(201)
      expect(payload.data).to eq({ id: '00000000-0000-0000-0000-000000000001',
                                   first_name: 'Taro',
                                   last_name: 'Yamada',
                                   email: 'taro.yamada@example.com' })
    end
  end

  describe 'defaults' do
    it 'uses default values when not provided' do
      payload = described_class.new
      expect(payload.id).to eq('')
      expect(payload.status_code).to eq(200)
      expect(payload.data).to eq([])
    end
  end
end
