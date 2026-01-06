# frozen_string_literal: true

require_relative '../../../spec_helper'

RSpec.describe Presentation::Request::User::CreateUserRequest do
  def valid_params
    { first_name: 'Taro', last_name: 'Yamada', email: 'taro.yamada@example.com' }
  end

  def capture_bad_request_error
    yield
    nil
  rescue Presentation::Exception::BadRequestException => e
    e
  end

  it 'builds request when valid' do
    req = described_class.build(params: valid_params)
    expect(req).to be_a(described_class)
  end

  it 'converts to dto of correct type' do
    dto = described_class.build(params: valid_params).convert_to_dto
    expect(dto).to be_a(Application::Dto::User::CreateUserInputDto)
  end

  it 'converts to dto with correct first_name' do
    dto = described_class.build(params: valid_params).convert_to_dto
    expect(dto.first_name).to eq('Taro')
  end

  it 'converts to dto with correct last_name' do
    dto = described_class.build(params: valid_params).convert_to_dto
    expect(dto.last_name).to eq('Yamada')
  end

  it 'converts to dto with correct email' do
    dto = described_class.build(params: valid_params).convert_to_dto
    expect(dto.email).to eq('taro.yamada@example.com')
  end

  it 'raises BadRequestException when fields are empty' do
    expect { described_class.build(params: {}) }
      .to raise_error(Presentation::Exception::BadRequestException)
  end

  it 'provides error details when fields are empty' do
    error = capture_bad_request_error { described_class.build(params: {}) }
    error_data = JSON.parse(error.message)
    expect(error_data).to eq({ 'email' => ['is missing'], 'first_name' => ['is missing'],
                               'last_name' => ['is missing'] })
  end

  it 'raises BadRequestException when fields are blank' do
    expect { described_class.build(params: { first_name: '', last_name: '', email: '' }) }
      .to raise_error(Presentation::Exception::BadRequestException)
  end

  it 'provides error details when fields are blank' do
    error = capture_bad_request_error { described_class.build(params: { first_name: '', last_name: '', email: '' }) }
    error_data = JSON.parse(error.message)
    expect(error_data).to eq({ 'email' => ['must be filled'], 'first_name' => ['must be filled'],
                               'last_name' => ['must be filled'] })
  end

  it 'raises BadRequestException when email is invalid format' do
    expect { described_class.build(params: { first_name: 'Taro', last_name: 'Yamada', email: 'not-an-email' }) }
      .to raise_error(Presentation::Exception::BadRequestException)
  end

  it 'provides error details when email is invalid format' do
    error = capture_bad_request_error do
      described_class.build(params: { first_name: 'Taro', last_name: 'Yamada', email: 'not-an-email' })
    end
    error_data = JSON.parse(error.message)
    expect(error_data).to eq({ 'email' => ['is in invalid format'] })
  end
end
