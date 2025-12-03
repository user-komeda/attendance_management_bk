# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Application::UseCase::User::UpdateUserUseCase do
  let(:use_case) { described_class.new }
  let(:fake_repo) { instance_double(::Domain::Repository::User::UserRepository) }
  let(:existing) { build_user(id: 5, first_name: 'Old', last_name: 'Name', email: 'old@example.com') }
  let(:updated)  { build_user(id: 5, first_name: 'New', last_name: 'Name', email: 'new@example.com') }

  def build_user(id: 1, first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com')
    entity = ::Domain::Entity::User::UserEntity.build(first_name: first_name, last_name: last_name, email: email)
    entity.id = ::Domain::ValueObject::IdentityId.build(id)
    entity
  end

  def build_update_input(id: 5, first_name: 'New', last_name: 'Name', email: 'new@example.com')
    ::Application::Dto::User::UpdateUserInputDto.new(
      id: id,
      first_name: first_name,
      last_name: last_name,
      email: email
    )
  end

  before do
    allow(fake_repo).to receive(:get_by_id).with(5).and_return(existing)
    allow(fake_repo).to receive(:update).with(instance_of(::Domain::Entity::User::UserEntity)).and_return(updated)
    allow(use_case).to receive(:resolve).and_return(fake_repo)
  end

  it 'updates and returns user dto' do
    expect(use_case.invoke(build_update_input)).to have_attributes(
      id: 5, first_name: 'New', last_name: 'Name', email: 'new@example.com'
    )
  end

  context 'when target user is missing' do
    before do
      allow(fake_repo).to receive(:get_by_id).with(123).and_return(nil)
      allow(use_case).to receive(:resolve).and_return(fake_repo)
    end

    it 'raises not found' do
      expect do
        use_case.invoke(build_update_input(id: 123, first_name: 'A', last_name: 'B', email: 'a@example.com'))
      end.to raise_error(::Application::Exception::NotFoundException)
    end
  end
end
