# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe AppEnv do
  describe '.validate!' do
    context 'when required env vars are missing' do
      it 'raises an error' do
        allow(ENV).to receive(:to_h).and_return({})
        expect { described_class.validate! }.to raise_error(RuntimeError)
      end
    end
  end
end
