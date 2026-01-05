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

RSpec.describe Presentation::Response::Factory::ResponseFactory do
  describe '.create_response' do
    context 'with 200 OK' do
      subject(:body) do
        described_class.create_response(
          response: response,
          status_code: 200,
          data: [
            {
              id: '00000000-0000-0000-0000-000000000001',
              first_name: 'Taro',
              last_name: 'Yamada',
              email: 'taro.yamada@example.com'
            }
          ]
        )
      end

      let(:response) { DummyResponse.new }

      it 'sets status code to 200' do
        body
        expect(response.status).to eq(200)
      end

      it 'sets Content-Type to application/json' do
        body
        expect(response['Content-Type']).to eq('application/json')
      end

      it 'includes id in JSON body' do
        parsed = JSON.parse(body)
        expect(parsed.first['id']).to eq('00000000-0000-0000-0000-000000000001')
      end

      it 'includes first_name in JSON body' do
        parsed = JSON.parse(body)
        expect(parsed.first['first_name']).to eq('Taro')
      end

      it 'includes last_name in JSON body' do
        parsed = JSON.parse(body)
        expect(parsed.first['last_name']).to eq('Yamada')
      end

      it 'includes email in JSON body' do
        parsed = JSON.parse(body)
        expect(parsed.first['email']).to eq('taro.yamada@example.com')
      end
    end

    context 'with 201 Created' do
      subject(:body) do
        described_class.create_response(
          response: response,
          status_code: 201,
          id: '00000000-0000-0000-0000-000000000001',
          data: {
            id: '00000000-0000-0000-0000-000000000001',
            first_name: 'Taro',
            last_name: 'Yamada',
            email: 'taro.yamada@example.com'
          },
          resource_name: 'users'
        )
      end

      let(:response) { DummyResponse.new }

      it 'sets status code to 201' do
        body
        expect(response.status).to eq(201)
      end

      it 'sets Content-Type to application/json' do
        body
        expect(response['Content-Type']).to eq('application/json')
      end

      it 'sets Location header' do
        body
        expect(response['Location']).to match('http://localhost:8080/users/00000000-0000-0000-0000-000000000001')
      end

      it 'includes id in JSON body' do
        parsed = JSON.parse(body)
        expect(parsed['id']).to eq('00000000-0000-0000-0000-000000000001')
      end

      it 'includes first_name in JSON body' do
        parsed = JSON.parse(body)
        expect(parsed['first_name']).to eq('Taro')
      end

      it 'includes last_name in JSON body' do
        parsed = JSON.parse(body)
        expect(parsed['last_name']).to eq('Yamada')
      end

      it 'includes email in JSON body' do
        parsed = JSON.parse(body)
        expect(parsed['email']).to eq('taro.yamada@example.com')
      end
    end

    context 'with 204 No Content' do
      subject(:body) do
        described_class.create_response(
          response: response,
          status_code: 204,
          id: '00000000-0000-0000-0000-000000000001',
          data: {
            id: '00000000-0000-0000-0000-000000000001',
            first_name: 'Taro',
            last_name: 'Yamada',
            email: 'taro.yamada@example.com'
          }
        )
      end

      let(:response) { DummyResponse.new }

      it 'sets status code to 204' do
        body
        expect(response.status).to eq(204)
      end

      it 'sets ETag header' do
        body
        expect(response['ETag']).to eq('00000000-0000-0000-0000-000000000001')
      end

      it 'returns nil body' do
        expect(body).to be_nil
      end
    end
  end

  describe '.responder' do
    let(:response) { DummyResponse.new }
    let(:payload) { Presentation::Controller::ControllerPayLoad.new(id: '', status_code: 418, data: []) }

    it 'raises on unsupported status code' do
      expect { described_class.responder(response: response, payload: payload) }.to raise_error(RuntimeError)
    end
  end
end
