# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Application::UseCase::User::GetAllUserUseCase do
  let(:use_case) { described_class.new }

  def build_user(id:, first_name:, last_name:, email:)
    entity = ::Domain::Entity::User::UserEntity.build(first_name: first_name, last_name: last_name, email: email)
    entity.id = ::Domain::ValueObject::IdentityId.build(id)
    entity
  end

  it 'returns empty array when no users' do
    fake_repo = double('UserRepository', get_all: [])
    allow(use_case).to receive(:resolve).and_return(fake_repo)

    result = use_case.invoke
    expect(result).to be_a(Array)
    expect(result).to be_empty
  end

  it 'returns user dto list' do
    u1 = build_user(id: 1, first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
    u2 = build_user(id: 2, first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com')

    fake_repo = double('UserRepository', get_all: [u1, u2])
    allow(use_case).to receive(:resolve).and_return(fake_repo)

    result = use_case.invoke
    expect(result.size).to eq(2)
    expect(result.first).to be_a(::Application::Dto::User::UserDto)

    expect(result.first.id).to eq(1)
    expect(result.first.first_name).to eq('Taro')
    expect(result.first.last_name).to eq('Yamada')
    expect(result.first.email).to eq('taro@example.com')

    expect(result.last.id).to eq(2)
    expect(result.last.first_name).to eq('Hanako')
    expect(result.last.last_name).to eq('Suzuki')
    expect(result.last.email).to eq('hanako@example.com')
  end
end
