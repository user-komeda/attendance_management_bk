# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::ContentApi::CreateContentApiUseCase do # rubocop:disable RSpec/MultipleMemoizedHelpers
  let(:work_space_id) { SecureRandom.uuid }
  let(:content_api_id) { SecureRandom.uuid }
  let(:content_api_repo) { instance_double(Domain::Repository::ContentApi::ContentApiRepository) }
  let(:content_api_service) { instance_double(Domain::Service::ContentApi::ContentApiService) }
  let(:rom_gateway) { instance_double(ROM::Gateway) }
  let(:rom_config) { instance_double(ROM::Configuration, gateways: { default: rom_gateway }) }

  let(:use_case) do
    described_class.new.tap do |uc|
      allow(uc).to receive(:resolve).with(described_class::CONTENT_API_REPOSITORY).and_return(content_api_repo)
      allow(uc).to receive(:resolve).with(described_class::CONTENT_API_SERVICE).and_return(content_api_service)
      allow(uc).to receive(:resolve).with('db.config').and_return(rom_config)
    end
  end

  let(:field_entity) do
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

  let(:result_entity) do
    Domain::Entity::ContentApi::ContentApiEntity.build_with_id(
      id: content_api_id,
      work_space_id: work_space_id,
      name: 'Test API',
      endpoint: 'test-api',
      api_type: 'list',
      fields: [field_entity]
    )
  end

  let(:work_space_slug) { 'test-workspace' }
  let(:work_space_entity) do
    id_vo = instance_double(Domain::ValueObject::IdentityId, value: work_space_id)
    instance_double(Domain::Entity::WorkSpace::WorkSpaceEntity, id: id_vo)
  end
  let(:input_dto) { instance_double(Application::Dto::ContentApi::CreateContentApiWithFieldsInputDto) }
  let(:content_api_entity) do
    Domain::Entity::ContentApi::ContentApiEntity.build(
      work_space_id: work_space_id,
      name: 'Test API',
      endpoint: 'test-api',
      api_type: 'list',
      fields: [field_entity]
    )
  end

  before do
    allow(rom_gateway).to receive(:transaction).and_yield
    allow(input_dto).to receive_messages(work_space_slug: work_space_slug, convert_to_entity: content_api_entity)
  end

  describe '#invoke' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    context 'when endpoint does not exist and field_ids are unique' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      before do
        allow(content_api_service).to receive_messages(endpoint_exists?: false, duplicate_field_id?: false)
        allow(content_api_service).to receive(:find_work_space_by_slug).and_return(work_space_entity)
        allow(content_api_repo).to receive(:create).and_return(result_entity)
      end

      it 'returns ContentApiWithFieldsDto' do
        result = use_case.invoke(arg: input_dto)
        aggregate_failures do
          expect(result).to be_a(Application::Dto::ContentApi::ContentApiWithFieldsDto)
          expect(result.content_api.name).to eq('Test API')
        end
      end
    end

    context 'when workspace is not found' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      before do
        allow(content_api_service).to receive(:find_work_space_by_slug).and_return(nil)
      end

      it 'raises NotFoundException' do
        expect { use_case.invoke(arg: input_dto) }
          .to raise_error(Application::Exception::NotFoundException, 'workspace not found')
      end
    end

    context 'when endpoint already exists' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      before do
        allow(content_api_service).to receive_messages(find_work_space_by_slug: work_space_entity,
                                                       endpoint_exists?: true)
      end

      it 'raises DuplicatedException' do
        expect { use_case.invoke(arg: input_dto) }
          .to raise_error(Application::Exception::DuplicatedException, 'endpoint already exists')
      end
    end

    context 'when field_ids are duplicated' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      before do
        allow(content_api_service).to receive_messages(endpoint_exists?: false, duplicate_field_id?: true)
        allow(content_api_service).to receive(:find_work_space_by_slug).and_return(work_space_entity)
      end

      it 'raises DuplicatedException' do
        expect { use_case.invoke(arg: input_dto) }
          .to raise_error(Application::Exception::DuplicatedException, 'field_id must be unique')
      end
    end
  end
end
