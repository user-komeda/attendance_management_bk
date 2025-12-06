# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::ValueObject::User::UserEmail do
  describe '.build' do
    it 'builds a value object with given email' do
      email = described_class.build('taro@example.com')
      expect(email).to be_a(described_class)
    end

    it 'sets the given email value' do
      expect(described_class.build('taro@example.com').value).to eq('taro@example.com')
    end

    it 'freezes the instance' do
      expect(described_class.build('taro@example.com')).to be_frozen
    end

    it 'raises ArgumentError when email is nil' do
      expect { described_class.build(nil) }.to raise_error(ArgumentError)
    end

    it 'allows empty string (current implementation)' do
      email = described_class.build('')
      expect(email.value).to eq('')
    end
  end

  describe '#values' do
    it 'returns an array containing the email value' do
      email = described_class.build('hanako@example.com')
      expect(email.values).to eq(['hanako@example.com'])
    end
  end

  describe 'equality and hash' do
    let(:a) { described_class.build('same@example.com') }
    let(:b) { described_class.build('same@example.com') }
    let(:c) { described_class.build('other@example.com') }

    it 'is equal when values are equal' do
      expect(a).to eq(b)
    end

    it 'is not equal when values differ' do
      expect(a).not_to eq(c)
    end

    it 'has identical hash for equal values' do
      expect(a.hash).to eq(b.hash)
    end
  end
end
