# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::Repository::User::UserRepository do
  let(:repo) { described_class.new }
  let(:infra_repo_interface) do
    Class.new do
      def get_all; end
      def get_by_id(_id); end
      def create(_obj); end
      def update(_obj); end
      def delete(_obj); end
      def find_by_email(_email); end
    end
  end

  it 'delegates get_all' do
    fake = instance_spy(infra_repo_interface, get_all: [:ok])
    allow(repo).to receive(:resolve).and_return(fake)

    result = repo.get_all
    expect(result).to eq([:ok])
  end

  it 'delegates get_by_id' do
    fake = instance_spy(infra_repo_interface, get_by_id: :user)
    allow(repo).to receive(:resolve).and_return(fake)

    result = repo.get_by_id(123)
    expect(result).to eq(:user)
  end

  it 'delegates create' do
    obj = Object.new
    fake = instance_spy(infra_repo_interface, create: :created)
    allow(repo).to receive(:resolve).and_return(fake)

    result = repo.create(obj)
    expect(result).to eq(:created)
  end

  it 'delegates update' do
    obj = Object.new
    fake = instance_spy(infra_repo_interface, update: :updated)
    allow(repo).to receive(:resolve).and_return(fake)

    result = repo.update(obj)
    expect(result).to eq(:updated)
  end

  it 'delegates delete' do
    obj = Object.new
    fake = instance_spy(infra_repo_interface, delete: :deleted)
    allow(repo).to receive(:resolve).and_return(fake)

    result = repo.delete(obj)
    expect(result).to eq(:deleted)
  end

  it 'delegates find_by_email' do
    fake = instance_spy(infra_repo_interface, find_by_email: :found)
    allow(repo).to receive(:resolve).and_return(fake)

    result = repo.find_by_email('a@example.com')
    expect(result).to eq(:found)
  end
end
