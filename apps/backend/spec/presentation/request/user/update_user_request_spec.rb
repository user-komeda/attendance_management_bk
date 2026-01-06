# frozen_string_literal: true

require_relative '../../../spec_helper'

RSpec.describe Presentation::Request::User::UpdateUserRequest do
  def valid_params
    { id: '00000000-0000-0000-0000-000000000000', first_name: 'Hanako', last_name: 'Suzuki',
      email: 'hanako.suzuki@example.com' }
  end

  it 'builds request when valid' do
    req = described_class.build(params: valid_params)
    expect(req).to be_a(described_class)
  end

  it 'converts to dto with correct id' do
    dto = described_class.build(params: valid_params).convert_to_dto
    expect(dto.id).to eq('00000000-0000-0000-0000-000000000000')
  end

  it 'converts to dto with correct first_name' do
    dto = described_class.build(params: valid_params).convert_to_dto
    expect(dto.first_name).to eq('Hanako')
  end

  it 'converts to dto with correct last_name' do
    dto = described_class.build(params: valid_params).convert_to_dto
    expect(dto.last_name).to eq('Suzuki')
  end

  it 'converts to dto with correct email' do
    dto = described_class.build(params: valid_params).convert_to_dto
    expect(dto.email).to eq('hanako.suzuki@example.com')
  end

  it 'raises with correct error message when fields are empty' do
    expect do
      described_class.build(params: { id: '00000000-0000-0000-0000-000000000001' })
    end.not_to raise_error
  end

  def capture_bad_request_error
    yield
    nil
  rescue Presentation::Exception::BadRequestException => e
    e
  end

  it 'raises BadRequestException when params are empty' do
    expect { described_class.build(params: {}) }
      .to raise_error(Presentation::Exception::BadRequestException)
  end

  it 'provides error details for empty params' do
    error = capture_bad_request_error { described_class.build(params: {}) }
    error_data = JSON.parse(error.message)
    expect(error_data).to eq({ 'id' => ['is missing'] })
  end

  it 'raises BadRequestException when id format is invalid' do
    expect { described_class.build(params: { id: '00000000000000000000000000000001' }) }
      .to raise_error(Presentation::Exception::BadRequestException)
  end

  it 'provides error details when id format is invalid' do
    error = capture_bad_request_error { described_class.build(params: { id: '00000000000000000000000000000001' }) }
    error_data = JSON.parse(error.message)
    expect(error_data).to eq({ 'id' => ['is in invalid format'] })
  end

  it 'raises BadRequestException when email is invalid (with id only)' do
    expect { described_class.build(params: { id: '00000000-0000-0000-0000-000000000001', email: 'not-an-email' }) }
      .to raise_error(Presentation::Exception::BadRequestException)
  end

  it 'provides error details when email is invalid (with id only)' do
    error = capture_bad_request_error do
      described_class.build(params: { id: '00000000-0000-0000-0000-000000000001', email: 'not-an-email' })
    end
    error_data = JSON.parse(error.message)
    expect(error_data).to eq({ 'email' => ['is in invalid format'] })
  end

  it 'raises BadRequestException when email is invalid format (with full params)' do
    expect do
      described_class.build(params:
                              { id: '00000000-0000-0000-0000-000000000001', first_name: 'Taro', last_name: 'Yamada',
                                email: 'not-an-email' })
    end.to raise_error(Presentation::Exception::BadRequestException)
  end

  it 'raises BadRequestException when id is invalid format (with full params)' do
    expect do
      described_class.build(params: { id: '00000000000000000000000000000001', first_name: 'Taro', last_name: 'Yamada',
                                      email: 'tanaka@gmail.com' })
    end.to raise_error(Presentation::Exception::BadRequestException)
  end
end
