# frozen_string_literal: true

require 'spec_helper'

class DummyResponse
  attr_accessor :status

  def initialize
    @headers = {}
    @status = 200
  end

  def []=(key, value)
    @headers[key] = value
  end

  def [](key)
    @headers[key]
  end
end

RSpec.describe Presentation::Response::Factory::NoContentResponder do
  describe '.build_responder' do
    let(:response) { DummyResponse.new }

    context 'when id is present' do
      subject(:result) do
        described_class.build_responder(
          response: response,
          payload: Presentation::Controller::ControllerPayLoad.new(
            id: '00000000-0000-0000-0000-000000000001',
            status_code: 204,
            data: []
          )
        )
      end

      it 'sets status code to 204' do
        result
        expect(response.status).to eq(204)
      end

      it 'sets ETag header to id' do
        result
        expect(response['ETag']).to eq('00000000-0000-0000-0000-000000000001')
      end

      it 'returns nil' do
        expect(result).to be_nil
      end
    end

    context 'when id is empty' do
      subject(:result) do
        described_class.build_responder(
          response: response,
          payload: Presentation::Controller::ControllerPayLoad.new(
            id: '',
            status_code: 204,
            data: []
          )
        )
      end

      it 'sets status code to 204' do
        result
        expect(response.status).to eq(204)
      end

      it 'does not set ETag header' do
        result
        expect(response['ETag']).to be_nil
      end

      it 'returns nil' do
        expect(result).to be_nil
      end
    end
  end
end
