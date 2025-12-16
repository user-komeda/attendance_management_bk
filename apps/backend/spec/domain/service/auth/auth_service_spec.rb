# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::Service::Auth::AuthService do
  let(:service) { described_class.new }

  describe '#exist?' do
    let(:repo_double) { instance_double(Infrastructure::Repository::Auth::AuthRepository) }

    it 'returns true when repository finds a record' do
      allow(service).to receive(:resolve)
        .with(described_class::REPOSITORY_KEY)
        .and_return(repo_double)

      allow(repo_double).to receive(:find_by_email).with('taro@example.com').and_return(:found)

      expect(service.exist?('taro@example.com')).to be true
    end

    it 'returns false when repository returns nil' do
      allow(service).to receive(:resolve)
        .with(described_class::REPOSITORY_KEY)
        .and_return(repo_double)

      allow(repo_double).to receive(:find_by_email).with('nobody@example.com').and_return(nil)

      expect(service.exist?('nobody@example.com')).to be false
    end

    it 'resolves repository via REPOSITORY_KEY' do
      allow(service).to receive(:resolve).and_return(repo_double)
      allow(repo_double).to receive(:find_by_email).and_return(nil)

      service.exist?('x@example.com')

      expect(service).to have_received(:resolve).with(described_class::REPOSITORY_KEY)
    end
  end
end
