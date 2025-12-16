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
end
