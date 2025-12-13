# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::User::GetAllUserUseCase do
  let(:use_case) { described_class.new }

  def build_user(id:, first_name:, last_name:, email:)
    Domain::Entity::User::UserEntity.build_with_id(
      id: id,
      first_name: first_name,
      last_name: last_name,
      email: email
    )
  end

  it 'returns empty array when no users' do
    fake_repo = instance_double(Domain::Repository::User::UserRepository)
    allow(fake_repo).to receive(:get_all).and_return([])
    allow(use_case).to receive(:resolve).and_return(fake_repo)

    result = use_case.invoke
    expect(result).to eq([])
  end

  context 'when users exist' do
    subject(:result) { use_case.invoke }

    let(:taro) { build_user(id: '1', first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com') }
    let(:hanako) { build_user(id: '2', first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com') }
    let(:fake_repo) { instance_double(Domain::Repository::User::UserRepository) }

    before do
      allow(fake_repo).to receive(:get_all).and_return([taro, hanako])
      allow(use_case).to receive(:resolve).and_return(fake_repo)
    end

    it 'returns user dto list' do
      expect(result).to contain_exactly(
        have_attributes(id: '1', first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com'),
        have_attributes(id: '2', first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com')
      )
    end
  end
end
