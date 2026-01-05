# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::ValueObject::WorkSpace::Role do
  describe '.build' do
    %w[owner admin editor viewer].each do |role|
      it "succeeds with #{role}" do
        expect(described_class.build(role).value).to eq(role)
      end
    end

    it 'raises ArgumentError with invalid role' do
      expect { described_class.build('invalid') }.to raise_error(ArgumentError, /Values not permitted in status/)
    end
  end

  describe '#values' do
    it 'returns the value in an array' do
      role = described_class.build('owner')
      expect(role.values).to eq(['owner'])
    end
  end
end
