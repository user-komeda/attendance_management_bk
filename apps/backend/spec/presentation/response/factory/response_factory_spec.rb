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
    it 'builds 200 OK response with JSON body' do
      response = DummyResponse.new
      body = described_class.create_response(
        response: response, status_code: 200, data: [id: '00000000-0000-0000-0000-000000000001',
                                                     first_name: 'Taro',
                                                     last_name: 'Yamada',
                                                     email: 'taro.yamada@example.com']
      )
      expect(response.status).to eq(200)
      expect(response['Content-Type']).to eq('application/json')
      parsed = JSON.parse(body)
      expect(parsed).to eq([{ 'id' => '00000000-0000-0000-0000-000000000001', 'first_name' => 'Taro',
                              'last_name' => 'Yamada', 'email' => 'taro.yamada@example.com' }])
    end

    it 'builds 201 Created with Location header' do
      response = DummyResponse.new
      body = described_class.create_response(
        response: response, status_code: 201, id: '00000000-0000-0000-0000-000000000001', data: { id: '00000000-0000-0000-0000-000000000001',
                                                                                                  first_name: 'Taro',
                                                                                                  last_name: 'Yamada',
                                                                                                  email: 'taro.yamada@example.com' }
      )
      expect(response.status).to eq(201)
      expect(response['Content-Type']).to eq('application/json')
      expect(response['Location']).to match('http://localhost:8080/users/00000000-0000-0000-0000-000000000001')
      parsed = JSON.parse(body)
      expect(parsed).to eq({ 'id' => '00000000-0000-0000-0000-000000000001', 'first_name' => 'Taro',
                             'last_name' => 'Yamada',
                             'email' => 'taro.yamada@example.com' })
    end

    it 'builds 204 No Content with nil body' do
      response = DummyResponse.new
      body = described_class.create_response(
        response: response, status_code: 204, id: '00000000-0000-0000-0000-000000000001', data: { id: '00000000-0000-0000-0000-000000000001',
                                                                                                  first_name: 'Taro',
                                                                                                  last_name: 'Yamada',
                                                                                                  email: 'taro.yamada@example.com' }
      )
      expect(response.status).to eq(204)
      expect(response['ETag']).to eq('00000000-0000-0000-0000-000000000001')

      expect(body).to be_nil
    end
  end

  describe '.responder' do
    it 'raises on unsupported status code' do
      response = DummyResponse.new
      expect do
        described_class.responder(
          response: response,
          payload: Presentation::Controller::ControllerPayLoad.new(id: '', status_code: 418, data: [])
        )
      end.to raise_error(RuntimeError)
    end
  end
end
