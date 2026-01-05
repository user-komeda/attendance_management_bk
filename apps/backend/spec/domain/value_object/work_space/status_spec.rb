# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::ValueObject::WorkSpace::Status do
  describe '.build' do
    %w[active pending suspend].each do |status|
      it "succeeds with #{status}" do
        expect(described_class.build(status).value).to eq(status)
      end
    end

    it 'raises ArgumentError with invalid status' do
      expect { described_class.build('invalid') }.to raise_error(ArgumentError, /Values not permitted in status/)
    end
  end

  describe '#values' do
    it 'returns the value in an array' do
      status = described_class.build('active')
      expect(status.values).to eq(['active'])
    end
  end
end
