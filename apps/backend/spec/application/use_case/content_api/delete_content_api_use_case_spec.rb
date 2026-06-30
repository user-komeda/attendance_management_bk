# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::ContentApi::DeleteContentApiUseCase do
  let(:content_api_id) { SecureRandom.uuid }
  let(:work_space_id) { SecureRandom.uuid }
  let(:work_space_slug) { 'test-workspace' }
  let(:content_api_repo) { instance_double(Domain::Repository::ContentApi::ContentApiRepository) }
  let(:content_api_service) { instance_double(Domain::Service::ContentApi::ContentApiService) }

  def rom_gateway
    @rom_gateway ||= instance_double(ROM::Gateway)
  end

  def rom_config
    @rom_config ||= instance_double(ROM::Configuration, gateways: { default: rom_gateway })
  end

  def use_case
    @use_case ||= described_class.new.tap { |uc| stub_dependencies(use_case: uc) }
  end

  def stub_dependencies(use_case:)
    stub_content_api_repository(use_case: use_case)
    stub_content_api_service(use_case: use_case)
    stub_rom_config(use_case: use_case)
  end

  def stub_content_api_repository(use_case:)
    allow(use_case).to receive(:resolve).with(described_class::CONTENT_API_REPOSITORY).and_return(content_api_repo)
  end

  def stub_content_api_service(use_case:)
    allow(use_case).to receive(:resolve).with(described_class::CONTENT_API_SERVICE).and_return(content_api_service)
  end

  def stub_rom_config(use_case:)
    allow(use_case).to receive(:resolve).with('db.config').and_return(rom_config)
  end

  def content_api_entity
    work_space_id_vo = instance_double(Domain::ValueObject::IdentityId, value: work_space_id)
    instance_double(Domain::Entity::ContentApi::ContentApiEntity, work_space_id: work_space_id_vo)
  end

  def work_space_entity
    id_vo = instance_double(Domain::ValueObject::IdentityId, value: work_space_id)
    instance_double(Domain::Entity::WorkSpace::WorkSpaceEntity, id: id_vo)
  end

  before do
    allow(rom_gateway).to receive(:transaction).and_yield
  end

  describe '#invoke' do
    context 'when content_api is not found' do
      before do
        allow(content_api_repo).to receive(:find_by_id).and_return(nil)
      end

      it 'raises NotFoundException' do
        expect { use_case.invoke(arg: content_api_id, work_space_id: work_space_slug) }
          .to raise_error(Application::Exception::NotFoundException, 'content_api not found')
      end
    end

    context 'when workspace is not found' do
      before do
        allow(content_api_repo).to receive(:find_by_id).and_return(content_api_entity)
        allow(content_api_service).to receive(:find_work_space_by_slug).and_return(nil)
      end

      it 'raises NotFoundException' do
        expect { use_case.invoke(arg: content_api_id, work_space_id: work_space_slug) }
          .to raise_error(Application::Exception::NotFoundException, 'workspace not found')
      end
    end

    context 'when workspace does not match content_api' do
      def other_work_space_entity
        id_vo = instance_double(Domain::ValueObject::IdentityId, value: SecureRandom.uuid)
        instance_double(Domain::Entity::WorkSpace::WorkSpaceEntity, id: id_vo)
      end

      before do
        allow(content_api_repo).to receive(:find_by_id).and_return(content_api_entity)
        allow(content_api_service).to receive(:find_work_space_by_slug).and_return(other_work_space_entity)
      end

      it 'raises NotFoundException' do
        expect { use_case.invoke(arg: content_api_id, work_space_id: work_space_slug) }
          .to raise_error(Application::Exception::NotFoundException, 'content_api not found')
      end
    end

    context 'when delete is valid' do
      before do
        allow(content_api_repo).to receive(:find_by_id).and_return(content_api_entity)
        allow(content_api_service).to receive(:find_work_space_by_slug).and_return(work_space_entity)
        allow(content_api_repo).to receive(:delete_by_id)
      end

      it 'deletes the content_api' do
        use_case.invoke(arg: content_api_id, work_space_id: work_space_slug)
        expect(content_api_repo).to have_received(:delete_by_id).with(id: content_api_id)
      end
    end
  end
end
