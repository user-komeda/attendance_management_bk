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

  describe '#can_login?' do
    let(:auth_user) { instance_double(Domain::Entity::Auth::AuthUserEntity) }
    let(:password) { 'Password123!' }

    it 'returns true if user is active and password matches' do
      allow(auth_user).to receive(:active?).and_return(true)
      allow(auth_user).to receive(:password_match?).with(password).and_return(true)

      expect(service.can_login?(auth_user: auth_user, password: password)).to be true
    end

    it 'returns false if user is not active' do
      allow(auth_user).to receive(:active?).and_return(false)

      expect(service.can_login?(auth_user: auth_user, password: password)).to be false
    end

    it 'returns false if password does not match' do
      allow(auth_user).to receive(:active?).and_return(true)
      allow(auth_user).to receive(:password_match?).with(password).and_return(false)

      expect(service.can_login?(auth_user: auth_user, password: password)).to be false
    end
  end
end
