# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Repository::Rom::Auth::AuthRomRepository do
  let(:fake_relation_class) do
    Class.new do
      attr_accessor :rows, :mapped_class

      def initialize(rows, mapped_class = nil)
        @rows = rows
        @mapped_class = mapped_class
      end

      def map_to(klass)
        self.mapped_class = klass
        self
      end

      def by_email(_email)
        self
      end

      def first
        rows.first
      end
    end
  end

  def create_repo_instance
    mock_container = instance_double(Object)
    repo = described_class.allocate
    repo.instance_variable_set(:@container, mock_container)
    repo.send(:initialize, container: mock_container)
    repo
  end

  def build_infra_auth_user(attributes = {})
    default_attributes = {
      id: 'auth-1',
      user_id: 'user-1',
      email: 'taro@example.com',
      provider: 'email',
      password_digest: 'hashed',
      last_login_at: nil,
      is_active: true
    }
    Infrastructure::Entity::Auth::AuthUserEntity.new(default_attributes.merge(attributes))
  end

  describe '#find_by_email' do
    let(:repo) { create_repo_instance }

    context 'when a record exists' do
      let(:infra_entity) { build_infra_auth_user(email: 'taro@example.com') }
      let(:fake_auth_users) { fake_relation_class.new([infra_entity], nil) }

      before do
        allow(repo).to receive(:auth_users).and_return(fake_auth_users)
      end

      it 'returns an Infrastructure::Entity::Auth::AuthUserEntity' do
        result = repo.find_by_email(email: 'taro@example.com')
        expect(result).to have_attributes(
          class: Infrastructure::Entity::Auth::AuthUserEntity,
          email: 'taro@example.com'
        )
      end
    end

    context 'when no record exists' do
      let(:fake_auth_users) { fake_relation_class.new([], nil) }

      before do
        allow(repo).to receive(:auth_users).and_return(fake_auth_users)
      end

      it 'returns nil' do
        expect(repo.find_by_email(email: 'nobody@example.com')).to be_nil
      end
    end
  end
end
