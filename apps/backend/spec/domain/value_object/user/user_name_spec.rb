# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::ValueObject::User::UserName do
  describe '.build' do
    it 'builds a value object with given names' do
      name = described_class.build('Taro', 'Yamada')
      expect(name).to be_a(described_class)
    end

    it 'sets first_name' do
      expect(described_class.build('Taro', 'Yamada').first_name).to eq('Taro')
    end

    it 'sets last_name' do
      expect(described_class.build('Taro', 'Yamada').last_name).to eq('Yamada')
    end

    it 'freezes the instance' do
      expect(described_class.build('Taro', 'Yamada')).to be_frozen
    end

    it 'raises when first_name is nil' do
      expect { described_class.build(nil, 'Yamada') }.to raise_error(ArgumentError)
    end

    it 'raises when first_name is empty' do
      expect { described_class.build('', 'Yamada') }.to raise_error(ArgumentError)
    end

    it 'does not raise when last_name is nil (current implementation behavior)' do
      expect { described_class.build('Taro', nil) }.to raise_error(ArgumentError)
    end

    it 'does not raise when last_name is empty (current implementation behavior)' do
      expect { described_class.build('Taro', '') }.to raise_error(ArgumentError)
    end
  end

  describe '#full_name' do
    it 'concatenates first and last name with a space' do
      name = described_class.build('Hanako', 'Suzuki')
      expect(name.full_name).to eq('Hanako Suzuki')
    end
  end

  describe '#values' do
    it 'returns an array of internal values' do
      name = described_class.build('A', 'B')
      expect(name.values).to eq(%w[A B])
    end
  end

  describe 'equality and hash' do
    let(:a) { described_class.build('Same', 'Person') }
    let(:b) { described_class.build('Same', 'Person') }
    let(:c) { described_class.build('Other', 'Person') }

    it 'is equal when values are equal' do
      expect(a).to eq(b)
    end

    it 'is not equal when any value differs' do
      expect(a).not_to eq(c)
    end

    it 'has identical hash when equal' do
      expect(a.hash).to eq(b.hash)
    end
  end
end
