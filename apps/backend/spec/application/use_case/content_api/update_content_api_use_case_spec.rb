# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::ContentApi::UpdateContentApiUseCase do
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

  def work_space_entity
    id_vo = instance_double(Domain::ValueObject::IdentityId, value: work_space_id)
    instance_double(Domain::Entity::WorkSpace::WorkSpaceEntity, id: id_vo)
  end

  def existing_entity
    Domain::Entity::ContentApi::ContentApiEntity.build_with_id(
      id: content_api_id,
      work_space_id: work_space_id,
      name: 'Old API',
      endpoint: 'old-api',
      api_type: 'list',
      fields: [existing_field_entity]
    )
  end

  def existing_field_entity
    Domain::Entity::ContentApi::FieldEntity.build_with_id(
      id: SecureRandom.uuid,
      content_api_id: content_api_id,
      field_id: 'title',
      display_name: 'Title',
      field_type: 'text',
      required: true,
      unique_value: false,
      order_index: 0,
      is_active: true,
      settings: {}
    )
  end

  def input_dto
    content_api_input = Application::Dto::ContentApi::UpdateContentApiInputDto.new(
      params: { name: 'New API', endpoint: 'new-api', api_type: 'list' }
    )
    field_input = Application::Dto::ContentApi::CreateFieldInputDto.new(
      params: { field_id: 'title', display_name: 'Title', field_type: 'text' }
    )
    Application::Dto::ContentApi::UpdateContentApiWithFieldsInputDto.new(
      params: { id: content_api_id, work_space_id: work_space_slug, content_api: content_api_input,
                fields: [field_input] }
    )
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
        expect { use_case.invoke(arg: input_dto) }
          .to raise_error(Application::Exception::NotFoundException, 'content_api not found')
      end
    end

    context 'when workspace is not found' do
      before do
        allow(content_api_repo).to receive(:find_by_id).and_return(existing_entity)
        allow(content_api_service).to receive(:find_work_space_by_slug).and_return(nil)
      end

      it 'raises NotFoundException' do
        expect { use_case.invoke(arg: input_dto) }
          .to raise_error(Application::Exception::NotFoundException, 'workspace not found')
      end
    end

    context 'when workspace does not match content_api' do
      def other_work_space_entity
        id_vo = instance_double(Domain::ValueObject::IdentityId, value: SecureRandom.uuid)
        instance_double(Domain::Entity::WorkSpace::WorkSpaceEntity, id: id_vo)
      end

      before do
        allow(content_api_repo).to receive(:find_by_id).and_return(existing_entity)
        allow(content_api_service).to receive(:find_work_space_by_slug).and_return(other_work_space_entity)
      end

      it 'raises NotFoundException' do
        expect { use_case.invoke(arg: input_dto) }
          .to raise_error(Application::Exception::NotFoundException, 'content_api not found')
      end
    end

    context 'when endpoint already exists for another content_api' do
      before do
        allow(content_api_repo).to receive(:find_by_id).and_return(existing_entity)
        allow(content_api_service).to receive_messages(find_work_space_by_slug: work_space_entity,
                                                       endpoint_exists_excluding?: true)
      end

      it 'raises DuplicatedException' do
        expect { use_case.invoke(arg: input_dto) }
          .to raise_error(Application::Exception::DuplicatedException, 'endpoint already exists')
      end
    end

    context 'when field_ids are duplicated' do
      before do
        allow(content_api_repo).to receive(:find_by_id).and_return(existing_entity)
        allow(content_api_service).to receive(:find_work_space_by_slug).and_return(work_space_entity)
        allow(content_api_service).to receive_messages(endpoint_exists_excluding?: false, duplicate_field_id?: true)
      end

      it 'raises DuplicatedException' do
        expect { use_case.invoke(arg: input_dto) }
          .to raise_error(Application::Exception::DuplicatedException, 'field_id must be unique')
      end
    end

    context 'when update is valid' do
      before do
        allow(content_api_service).to receive(:find_work_space_by_slug).and_return(work_space_entity)
        allow(content_api_service).to receive_messages(endpoint_exists_excluding?: false, duplicate_field_id?: false)
        allow(content_api_repo).to receive_messages(find_by_id: existing_entity, update: existing_entity)
      end

      it 'returns ContentApiWithFieldsDto' do
        result = use_case.invoke(arg: input_dto)
        expect(result).to be_a(Application::Dto::ContentApi::ContentApiWithFieldsDto)
      end
    end
  end
end
