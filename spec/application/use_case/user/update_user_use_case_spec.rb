# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Application::UseCase::User::UpdateUserUseCase do
  let(:use_case) { described_class.new }

  def build_user(id: 1, first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com')
    entity = ::Domain::Entity::User::UserEntity.build(first_name: first_name, last_name: last_name, email: email)
    entity.id = ::Domain::ValueObject::IdentityId.build(id)
    entity
  end

  it 'updates and returns user dto' do
    existing = build_user(id: 5, first_name: 'Old', last_name: 'Name', email: 'old@example.com')
    updated = build_user(id: 5, first_name: 'New', last_name: 'Name', email: 'new@example.com')

    fake_repo = double('UserRepository')
    expect(fake_repo).to receive(:get_by_id).with(5).and_return(existing)
    expect(fake_repo).to receive(:update).with(instance_of(::Domain::Entity::User::UserEntity)).and_return(updated)
    allow(use_case).to receive(:resolve).and_return(fake_repo)

    input = ::Application::Dto::User::UpdateUserInputDto.new(id: 5, first_name: 'New', last_name: 'Name', email: 'new@example.com')
    dto = use_case.invoke(input)
    expect(dto.id).to eq(5)
    expect(dto.first_name).to eq('New')
    expect(dto.last_name).to eq('Name')
    expect(dto.email).to eq('new@example.com')
  end

  it 'raises not found when user missing' do
    fake_repo = double('UserRepository')
    expect(fake_repo).to receive(:get_by_id).with(123).and_return(nil)

    allow(use_case).to receive(:resolve).and_return(fake_repo)

    input = ::Application::Dto::User::UpdateUserInputDto.new(id: 123, first_name: 'A', last_name: 'B', email: 'a@example.com')
    expect { use_case.invoke(input) }.to raise_error(::Application::Exception::NotFoundException)
  end
end
