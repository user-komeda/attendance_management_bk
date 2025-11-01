# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Application::UseCase::User::GetDetailUserUseCase do
  let(:use_case) { described_class.new }

  def build_user(id: 1, first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
    entity = ::Domain::Entity::User::UserEntity.build(first_name: first_name, last_name: last_name, email: email)
    entity.id = ::Domain::ValueObject::IdentityId.build(id)
    entity
  end

  it 'returns user dto when user exists' do
    fake_repo = double('UserRepository')
    user = build_user(id: 10)
    expect(fake_repo).to receive(:get_by_id).with(10).and_return(user)

    allow(use_case).to receive(:resolve).and_return(fake_repo)

    dto = use_case.invoke(10)
    expect(dto).to be_a(::Application::Dto::User::UserDto)
    expect(dto.id).to eq(10)
    expect(dto.first_name).to eq('Taro')
    expect(dto.last_name).to eq('Yamada')
    expect(dto.email).to eq('taro@example.com')
  end

  it 'raises not found when user missing' do
    fake_repo = double('UserRepository')
    expect(fake_repo).to receive(:get_by_id).with(999).and_return(nil)

    allow(use_case).to receive(:resolve).and_return(fake_repo)

    expect { use_case.invoke(999) }.to raise_error(::Application::Exception::NotFoundException)
  end
end
