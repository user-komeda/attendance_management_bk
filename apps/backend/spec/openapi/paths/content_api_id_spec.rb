# frozen_string_literal: true

require 'securerandom'

require_relative '../spec_helper'

RSpec.describe 'ContentApiId', type: :openapi do
  let(:test_auth_user_id) { '04e8496c-6b8c-4f4f-9746-2d96a10f13ec' }
  let(:conn) { Container.resolve('db.config').gateways[:default].connection }
  let(:work_space_id) { insert_work_space(conn) }
  let(:content_api_id) { create_content_api(work_space_id) }

  def insert_user(conn, user_id)
    return if conn[:users].where(id: user_id).first

    conn[:users].insert(
      id: user_id,
      first_name: 'Content',
      last_name: 'ApiUser',
      email: "content-api-id-user-#{SecureRandom.uuid}@example.com"
    )
  end

  def insert_work_space(conn)
    insert_user(conn, test_auth_user_id)
    slug, work_space_id = generate_workspace_values
    conn[:work_spaces].insert(
      id: work_space_id,
      name: 'Test WorkSpace',
      slug: slug
    )
    conn[:member_ships].insert(
      id: SecureRandom.uuid,
      user_id: test_auth_user_id,
      work_space_id: work_space_id,
      role: 'owner',
      status: 'active'
    )
    slug
  end

  def generate_workspace_values
    ["ws-#{SecureRandom.hex(4)}", SecureRandom.uuid]
  end

  def create_content_api(work_space_id)
    request_body = create_content_api_request_body
    post "/work_spaces/#{work_space_id}/content_api", request_body.to_json, json_headers
    json(last_response.body).dig('content_api', 'id')
  end

  def create_content_api_request_body
    {
      name: 'Articles',
      endpoint: "art-#{SecureRandom.hex(4)}",
      api_type: 'list',
      fields: [create_content_api_field]
    }
  end

  def create_content_api_field
    {
      field_id: 'title',
      display_name: 'Title',
      field_type: 'text',
      required: false,
      unique_value: false,
      order_index: 0,
      is_active: true,
      settings: { max_length: 255 }
    }
  end

  describe 'GET /content_api/:id' do
    it 'returns 200' do
      get "/work_spaces/#{work_space_id}/content_api/#{content_api_id}"
      expect(last_response.status).to eq(200)
    end

    it 'touches ContentApiWithFields schema properties' do
      get "/work_spaces/#{work_space_id}/content_api/#{content_api_id}"
      body = json(last_response.body)
      expect(touch_openapi_schema_properties('ContentApiWithFields', body)).to be_a(Set)
    end

    it 'touches ContentApi schema properties' do
      get "/work_spaces/#{work_space_id}/content_api/#{content_api_id}"
      body = json(last_response.body)
      expect(touch_openapi_schema_properties('ContentApi', body['content_api'])).to be_a(Set)
    end

    it 'touches Field schema properties' do
      get "/work_spaces/#{work_space_id}/content_api/#{content_api_id}"
      body = json(last_response.body)
      body['fields'].each do |field|
        expect(touch_openapi_schema_properties('Field', field)).to be_a(Set)
      end
    end

    it 'returns 404 for nonexistent content_api' do
      get "/work_spaces/#{work_space_id}/content_api/#{SecureRandom.uuid}"
      expect(last_response.status).to eq(404)
    end
  end

  describe 'PATCH /content_api/:id' do
    let(:update_properties) do
      {
        name: 'Updated Articles',
        endpoint: "updated-#{SecureRandom.hex(4)}",
        api_type: 'list',
        fields: [
          {
            field_id: 'title',
            display_name: 'Updated Title',
            field_type: 'text',
            required: true,
            unique_value: false,
            order_index: 0,
            is_active: true,
            settings: { max_length: 500 }
          }
        ]
      }
    end

    it 'returns 204' do
      patch "/work_spaces/#{work_space_id}/content_api/#{content_api_id}", update_properties.to_json, json_headers
      expect(last_response.status).to eq(204)
    end

    it 'touches all optional schema properties for UpdateContentApiWithFieldsRequest' do
      aggregate_failures do
        expect(touch_openapi_schema_properties('UpdateContentApiWithFieldsRequest', update_properties)).to be_a(Set)
      end
    end

    it 'returns 400 with invalid params' do
      invalid_body = invalid_update_content_api_body
      patch "/work_spaces/#{work_space_id}/content_api/#{content_api_id}", invalid_body.to_json, json_headers
      expect(last_response.status).to eq(400)
    end

    it 'returns 404 for nonexistent content_api' do
      patch "/work_spaces/#{work_space_id}/content_api/#{SecureRandom.uuid}", update_properties.to_json, json_headers
      expect(last_response.status).to eq(404)
    end
  end

  describe 'DELETE /content_api/:id' do
    it 'returns 204' do
      delete "/work_spaces/#{work_space_id}/content_api/#{content_api_id}"
      expect(last_response.status).to eq(204)
    end

    it 'returns 404 for nonexistent content_api' do
      delete "/work_spaces/#{work_space_id}/content_api/#{SecureRandom.uuid}"
      expect(last_response.status).to eq(404)
    end
  end
end

def invalid_update_content_api_body
  {
    name: 'Updated',
    endpoint: 'updated',
    api_type: 'list',
    fields: [
      { field_id: '123invalid', display_name: 'Bad', field_type: 'invalid_type' }
    ]
  }
end
