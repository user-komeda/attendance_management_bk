# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::Service::User::UserService do
  let(:service) { described_class.new }

  def build_user(id: 1, first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
    entity = Domain::Entity::User::UserEntity.build(first_name: first_name, last_name: last_name, email: email)
    entity.id = Domain::ValueObject::IdentityId.build(id)
    entity
  end

  it 'returns true when repository finds user' do
    fake_repo = instance_double(Domain::Repository::User::UserRepository)
    allow(fake_repo).to receive(:find_by_email).with('foo@example.com').and_return(build_user(id: 9,
                                                                                              email: 'foo@example.com'))

    allow(service).to receive(:resolve).and_return(fake_repo)

    expect(service.exist?('foo@example.com')).to be(true)
  end

  it 'returns false when repository returns nil' do
    fake_repo = instance_double(Domain::Repository::User::UserRepository)
    allow(fake_repo).to receive(:find_by_email).with('bar@example.com').and_return(nil)

    allow(service).to receive(:resolve).and_return(fake_repo)

    expect(service.exist?('bar@example.com')).to be(false)
  end
end
