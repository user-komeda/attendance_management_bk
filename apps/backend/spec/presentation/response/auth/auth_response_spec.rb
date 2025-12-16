# frozen_string_literal: true

require_relative '../../../spec_helper'

RSpec.describe Presentation::Response::Auth::AuthResponse do
  describe '.build' do
    subject(:res) { described_class.build(id: 'auth-1', user_id: 'user-1') }

    it 'returns a hash' do
      expect(res).to be_a(Hash)
    end

    it 'sets id' do
      expect(res[:id]).to eq('auth-1')
    end

    it 'sets user_id' do
      expect(res[:user_id]).to eq('user-1')
    end
  end

  describe '#to_h' do
    subject(:result) { response.to_h }

    let(:response) { described_class.new(id: 'a-123', user_id: 'u-456') }

    it 'returns hash representation' do
      expect(result).to eq({ id: 'a-123', user_id: 'u-456' })
    end
  end
end
