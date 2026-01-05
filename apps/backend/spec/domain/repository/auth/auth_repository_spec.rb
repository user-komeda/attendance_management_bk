# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::Repository::Auth::AuthRepository do
  let(:repo) { described_class.new }

  it 'is a subclass of AuthRepositoryBase' do
    expect(described_class < Domain::Repository::Auth::AuthRepositoryBase).to be true
  end

  it 'has REPOSITORY_KEY defined in base class' do
    key = Domain::Repository::Auth::AuthRepositoryBase::REPOSITORY_KEY
    expect(key).to(satisfy { |k| k.is_a?(String) && !k.empty? })
  end

  it 'includes ContainerHelper via BaseRepository (responds to resolve)' do
    expect(repo).to respond_to(:resolve)
  end

  describe '#find_by_email' do
    let(:email) { 'test@example.com' }
    let(:infra_repo) { instance_double(Infrastructure::Repository::Auth::AuthRepository) }
    let(:auth_user) { instance_double(Infrastructure::Entity::Auth::AuthUserEntity) }

    before do
      allow(repo).to receive(:resolve).with(described_class::REPOSITORY_KEY).and_return(infra_repo)
    end

    it 'calls infra repository find_by_email' do
      allow(infra_repo).to receive(:find_by_email).with(email: email).and_return(auth_user)
      expect(repo.find_by_email(email: email)).to eq(auth_user)
    end
  end
end
