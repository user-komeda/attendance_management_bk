# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Repository::Auth::AuthRepository do
  let(:repo) { described_class.new }

  describe '#find_by_email' do
    let(:rom_repo) { instance_double(Infrastructure::Repository::Rom::Auth::AuthRomRepository) }

    context 'when infra entity is found' do
      let(:infra_entity) { instance_double(Infrastructure::Entity::Auth::AuthUserEntity) }
      let(:domain_entity) { instance_double(Domain::Entity::Auth::AuthUserEntity) }

      before do
        allow(repo).to receive(:resolve)
          .with(described_class::ROM_REPOSITORY_KEY)
          .and_return(rom_repo)

        allow(rom_repo).to receive(:find_by_email)
          .with('taro@example.com')
          .and_return(infra_entity)

        allow(infra_entity).to receive(:to_domain).and_return(domain_entity)
      end

      it 'delegates to ROM repository and maps to domain entity' do
        result = repo.find_by_email('taro@example.com')
        expect(result).to eq(domain_entity)
      end
    end

    context 'when not found' do
      before do
        allow(repo).to receive(:resolve)
          .with(described_class::ROM_REPOSITORY_KEY)
          .and_return(rom_repo)

        allow(rom_repo).to receive(:find_by_email)
          .with('nobody@example.com')
          .and_return(nil)
      end

      it 'returns nil' do
        expect(repo.find_by_email('nobody@example.com')).to be_nil
      end
    end
  end
end
