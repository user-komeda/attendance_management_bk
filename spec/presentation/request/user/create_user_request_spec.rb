
# frozen_string_literal: true

require_relative '../../../spec_helper'

RSpec.describe Presentation::Request::User::CreateUserRequest do
  def valid_params
    { first_name: 'Taro', last_name: 'Yamada', email: 'taro.yamada@example.com' }
  end

  it 'builds request and converts to dto when valid' do
    req = described_class.build(valid_params)
    expect(req).to be_a(described_class)
    dto = req.convert_to_dto
    expect(dto).to be_a(Application::Dto::User::CreateUserInputDto)
    expect(dto.first_name).to eq('Taro')
    expect(dto.last_name).to eq('Yamada')
    expect(dto.email).to eq('taro.yamada@example.com')
  end

  it 'raises with correct error message when fields are empty' do
    expect {
      described_class.build({ })
    }.to raise_error(Presentation::Exception::BadRequestException) do |error|
      error_data = JSON.parse(error.message)
      expect(error_data).to eq({ 'email' => ['is missing'],'first_name' => ['is missing'], 'last_name' => ['is missing'] })
    end
  end

  it 'raises with correct error message when fields are empty' do
    expect {
      described_class.build({ first_name: '', last_name: '', email: '' })
    }.to raise_error(Presentation::Exception::BadRequestException) do |error|
      error_data = JSON.parse(error.message)
      expect(error_data).to eq({ 'email' => ['must be filled'],'first_name' => ['must be filled'], 'last_name' => ['must be filled'] })
    end
  end

  it 'raises BadRequestException when email is invalid format' do
    expect {
      described_class.build({ first_name: 'Taro', last_name: 'Yamada', email: 'not-an-email' })
    }.to raise_error(Presentation::Exception::BadRequestException) do |error|
      error_data = JSON.parse(error.message)
      expect(error_data).to eq({ 'email' => ['is in invalid format'] })
    end
  end
end