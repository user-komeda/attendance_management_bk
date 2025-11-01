# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Application::UseCase::User::CreateUserUseCase do
  let(:use_case) { described_class.new }

  def build_user(id: 1, first_name: 'Jiro', last_name: 'Sato', email: 'jiro@example.com')
    entity = ::Domain::Entity::User::UserEntity.build(first_name: first_name, last_name: last_name, email: email)
    entity.id = ::Domain::ValueObject::IdentityId.build(id)
    entity
  end

  it 'raises duplicated when email exists' do
    fake_service = double('UserService', exist?: true)
    allow(use_case).to receive(:resolve).and_return(fake_service)

    input = ::Application::Dto::User::CreateUserInputDto.new(first_name: 'A', last_name: 'B', email: 'dup@example.com')
    expect { use_case.invoke(input) }.to raise_error(::Application::Exception::DuplicatedException)
  end

  it 'creates and returns user dto' do
    fake_service = double('UserService', exist?: false)

    created = build_user(id: 77, first_name: 'Ken', last_name: 'Tanaka', email: 'new@example.com')
    fake_repo = double('UserRepository')
    expect(fake_repo).to receive(:create).with(instance_of(::Domain::Entity::User::UserEntity)).and_return(created)
    # Return service on first resolve call, then repo
    call_count = 0
    allow(use_case).to receive(:resolve) do |_key|
      call_count += 1
      call_count == 1 ? fake_service : fake_repo
    end

    input = ::Application::Dto::User::CreateUserInputDto.new(first_name: 'Ken', last_name: 'Tanaka', email: 'new@example.com')
    dto = use_case.invoke(input)
    expect(dto.id).to eq(77)
    expect(dto.first_name).to eq('Ken')
    expect(dto.last_name).to eq('Tanaka')
    expect(dto.email).to eq('new@example.com')
  end
end
