# frozen_string_literal: true

require 'securerandom'

require_relative '../spec_helper'

RSpec.describe 'ContentApi', type: :openapi do
  let(:test_auth_user_id) { '04e8496c-6b8c-4f4f-9746-2d96a10f13ec' }
  let(:conn) { Container.resolve('db.config').gateways[:default].connection }

  def insert_user(conn, user_id)
    return if conn[:users].where(id: user_id).first

    conn[:users].insert(
      id: user_id,
      first_name: 'Content',
      last_name: 'ApiUser',
      email: "content-api-user-#{SecureRandom.uuid}@example.com"
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

  describe 'POST /content_api' do
    let(:work_space_id) { insert_work_space(conn) }
    let(:request_body) do
      {
        name: 'Articles',
        endpoint: 'articles',
        api_type: 'list',
        fields: [
          {
            field_id: 'title',
            display_name: 'Title',
            field_type: 'text',
            required: true,
            unique_value: false,
            order_index: 0,
            is_active: true,
            settings: { max_length: 255 }
          }
        ]
      }
    end

    it 'returns 201' do
      post "/work_spaces/#{work_space_id}/content_api", request_body.to_json, json_headers
      expect(last_response.status).to eq(201)
    end

    it 'touches CreateContentApiWithFieldsRequest schema properties' do
      post "/work_spaces/#{work_space_id}/content_api", request_body.to_json, json_headers
      json(last_response.body)
      expect(touch_openapi_schema_properties('CreateContentApiWithFieldsRequest', request_body)).to be_a(Set)
    end

    it 'touches ContentApiWithFields schema properties' do
      post "/work_spaces/#{work_space_id}/content_api", request_body.to_json, json_headers
      body = json(last_response.body)
      expect(touch_openapi_schema_properties('ContentApiWithFields', body)).to be_a(Set)
    end

    it 'touches ContentApi schema properties' do
      post "/work_spaces/#{work_space_id}/content_api", request_body.to_json, json_headers
      body = json(last_response.body)
      expect(touch_openapi_schema_properties('ContentApi', body['content_api'])).to be_a(Set)
    end

    it 'touches Field schema properties' do
      post "/work_spaces/#{work_space_id}/content_api", request_body.to_json, json_headers
      body = json(last_response.body)
      body['fields'].each do |field|
        expect(touch_openapi_schema_properties('Field', field)).to be_a(Set)
      end
    end

    it 'returns 400 with invalid params' do
      post "/work_spaces/#{work_space_id}/content_api",
           { name: '', endpoint: 'articles', api_type: 'list', fields: [] }.to_json, json_headers
      expect(last_response.status).to eq(400)
    end
  end
end
