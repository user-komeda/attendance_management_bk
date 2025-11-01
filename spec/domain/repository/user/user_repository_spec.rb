# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Domain::Repository::User::UserRepository do
  let(:repo) { described_class.new }

  it 'delegates get_all' do
    fake = double('InfraRepo', get_all: [:ok])
    allow(repo).to receive(:resolve).and_return(fake)

    result = repo.get_all
    expect(result).to eq([:ok])
  end

  it 'delegates get_by_id' do
    fake = double('InfraRepo')
    expect(fake).to receive(:get_by_id).with(123).and_return(:user)
    allow(repo).to receive(:resolve).and_return(fake)

    result = repo.get_by_id(123)
    expect(result).to eq(:user)
  end

  it 'delegates create' do
    obj = Object.new
    fake = double('InfraRepo')
    expect(fake).to receive(:create).with(obj).and_return(:created)
    allow(repo).to receive(:resolve).and_return(fake)

    result = repo.create(obj)
    expect(result).to eq(:created)
  end

  it 'delegates update' do
    obj = Object.new
    fake = double('InfraRepo')
    expect(fake).to receive(:update).with(obj).and_return(:updated)
    allow(repo).to receive(:resolve).and_return(fake)

    result = repo.update(obj)
    expect(result).to eq(:updated)
  end

  it 'delegates delete' do
    obj = Object.new
    fake = double('InfraRepo')
    expect(fake).to receive(:delete).with(obj).and_return(:deleted)
    allow(repo).to receive(:resolve).and_return(fake)

    result = repo.delete(obj)
    expect(result).to eq(:deleted)
  end

  it 'delegates find_by_email' do
    fake = double('InfraRepo')
    expect(fake).to receive(:find_by_email).with('a@example.com').and_return(:found)
    allow(repo).to receive(:resolve).and_return(fake)

    result = repo.find_by_email('a@example.com')
    expect(result).to eq(:found)
  end
end
