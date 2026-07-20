# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Response::Factory::Responder do
  describe '.build_responder' do
    let(:response) { instance_double(Rack::Response) }
    let(:payload) do
      Presentation::Controller::ControllerPayLoad.new(
        id: SecureRandom.uuid,
        status_code: 200,
        data: {}
      )
    end

    it 'touches optional arguments when they are present' do
      expect do
        described_class.send(:build_responder, response: response, payload: payload, resource_name: 'users')
      end.to raise_error(NotImplementedError, described_class::ABSTRACT_MESSAGE)
    end

    it 'raises NotImplementedError for base responder' do
      expect { described_class.send(:build_responder, response: nil, payload: payload) }
        .to raise_error(NotImplementedError, described_class::ABSTRACT_MESSAGE)
    end

    it 'raises ArgumentError when payload is nil' do
      expect { described_class.send(:build_responder, response: nil, payload: nil) }
        .to raise_error(ArgumentError, 'payload is required')
    end
  end
end
