# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::User::GetDetailUserUseCase do
  let(:use_case) { described_class.new }
  let(:fake_repo) { instance_double(Domain::Repository::User::UserRepository) }

  def build_user(id: 1, first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
    Domain::Entity::User::UserEntity.build_with_id(
      id: id,
      first_name: first_name,
      last_name: last_name,
      email: email
    )
  end

  context 'when user exists' do
    before do
      allow(fake_repo).to receive(:get_by_id).with('10').and_return(build_user(id: '10'))
      allow(use_case).to receive(:resolve).and_return(fake_repo)
    end

    it 'returns user dto' do
      dto = use_case.invoke('10')
      expect(dto).to have_attributes(id: '10', first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
    end
  end

  context 'when user missing' do
    before do
      allow(fake_repo).to receive(:get_by_id).with('999').and_return(nil)
      allow(use_case).to receive(:resolve).and_return(fake_repo)
    end

    it 'raises not found' do
      expect { use_case.invoke('999') }.to raise_error(Application::Exception::NotFoundException)
    end
  end
end
