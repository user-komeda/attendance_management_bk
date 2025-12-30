# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::ValueObject::IdentityId do
  describe '.build' do
    it 'builds a value object when value is present' do
      id = described_class.build('user-1')
      expect(id).to be_a(described_class)
    end

    it 'sets the given value' do
      expect(described_class.build('user-1').value).to eq('user-1')
    end

    it 'freezes the instance' do
      expect(described_class.build('user-1')).to be_frozen
    end

    it 'raises ArgumentError when value is nil' do
      expect { described_class.build(nil) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when value is empty string' do
      expect { described_class.build('') }.to raise_error(ArgumentError)
    end
  end

  describe '#values' do
    it 'returns an array of internal values for equality/hash' do
      id = described_class.build('abc')
      expect(id.values).to eq(['abc'])
    end
  end

  describe 'equality and hash semantics' do
    let(:a) { described_class.build('same') }
    let(:b) { described_class.build('same') }
    let(:c) { described_class.build('diff') }

    it 'is equal when values are equal' do
      expect(a).to eq(b)
    end

    it 'is not equal when values differ' do
      expect(a).not_to eq(c)
    end

    it 'produces identical hashes for equal values' do
      expect(a.hash).to eq(b.hash)
    end
  end
end
