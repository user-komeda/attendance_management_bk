# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Controller::ContentApi::ContentApiController do
  let(:controller) { described_class.new }
  let(:content_api_id) { SecureRandom.uuid }
  let(:work_space_id) { SecureRandom.uuid }
  let(:mock_use_case) { instance_double(Application::UseCase::ContentApi::GetDetailContentApiUseCase) }

  def field_dto
    instance_double(
      Application::Dto::ContentApi::FieldDto,
      id: SecureRandom.uuid,
      content_api_id: content_api_id,
      field_id: 'title',
      display_name: 'Title',
      field_type: 'text',
      required: false,
      unique_value: false,
      order_index: 0,
      is_active: true,
      settings: {}
    )
  end

  def content_api_dto
    instance_double(
      Application::Dto::ContentApi::ContentApiDto,
      id: content_api_id,
      work_space_id: work_space_id,
      name: 'Articles',
      endpoint: 'articles',
      api_type: 'list'
    )
  end

  def content_api_with_fields_dto
    instance_double(
      Application::Dto::ContentApi::ContentApiWithFieldsDto,
      content_api: content_api_dto,
      fields: [field_dto]
    )
  end

  before do
    allow(controller).to receive(:resolve).and_return(mock_use_case)
  end

  describe '#show' do
    before do
      allow(mock_use_case).to receive(:invoke).and_return(content_api_with_fields_dto)
    end

    it 'returns content_api with fields' do
      result = controller.show(content_api_id)
      expect(result[:content_api][:id]).to eq(content_api_id)
    end

    it 'raises ArgumentError with empty id' do
      expect { controller.show('') }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError with nil id' do
      expect { controller.show(nil) }.to raise_error(ArgumentError)
    end
  end

  describe '#create' do
    def params
      {
        work_space_id: work_space_id,
        name: 'Articles',
        endpoint: 'articles',
        api_type: 'list',
        fields: [{ field_id: 'title', display_name: 'Title', field_type: 'text' }]
      }
    end

    before do
      allow(mock_use_case).to receive(:invoke).and_return(content_api_with_fields_dto)
    end

    it 'creates a content_api' do
      result = controller.create(params)
      expect(result[:content_api][:id]).to eq(content_api_id)
    end
  end

  describe '#update' do
    def params
      {
        name: 'Updated Articles',
        endpoint: 'updated-articles',
        api_type: 'list',
        fields: [{ field_id: 'title', display_name: 'Title', field_type: 'text' }]
      }
    end

    before do
      allow(mock_use_case).to receive(:invoke).and_return(content_api_with_fields_dto)
    end

    it 'updates a content_api' do
      result = controller.update(params, content_api_id)
      expect(result[:content_api][:id]).to eq(content_api_id)
    end

    it 'raises ArgumentError with empty id' do
      expect { controller.update(params, '') }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError with nil id' do
      expect { controller.update(params, nil) }.to raise_error(ArgumentError)
    end
  end

  describe '#destroy' do
    let(:mock_delete_use_case) { instance_double(Application::UseCase::ContentApi::DeleteContentApiUseCase) }

    before do
      allow(controller).to receive(:resolve).and_return(mock_delete_use_case)
      allow(mock_delete_use_case).to receive(:invoke).with(arg: content_api_id, work_space_id: work_space_id)
    end

    it 'deletes a content_api' do
      controller.destroy(content_api_id, work_space_id)
      expect(mock_delete_use_case).to have_received(:invoke).with(arg: content_api_id, work_space_id: work_space_id)
    end

    it 'raises ArgumentError with empty id' do
      expect { controller.destroy('', work_space_id) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError with nil id' do
      expect { controller.destroy(nil, work_space_id) }.to raise_error(ArgumentError)
    end
  end
end
