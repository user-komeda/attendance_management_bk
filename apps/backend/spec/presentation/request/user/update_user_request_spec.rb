# frozen_string_literal: true

require_relative '../../../spec_helper'

RSpec.describe Presentation::Request::User::UpdateUserRequest do
  def valid_params
    { id: '00000000-0000-0000-0000-000000000000', first_name: 'Hanako', last_name: 'Suzuki',
      email: 'hanako.suzuki@example.com' }
  end

  it 'builds request and exposes dto values when valid' do
    req = described_class.build(valid_params)
    expect(req).to be_a(described_class)
    dto = req.convert_to_dto
    expect(dto.id).to eq('00000000-0000-0000-0000-000000000000')
    expect(dto.first_name).to eq('Hanako')
    expect(dto.last_name).to eq('Suzuki')
    expect(dto.email).to eq('hanako.suzuki@example.com')
  end

  it 'raises with correct error message when fields are empty' do
    expect do
      described_class.build({ id: '00000000-0000-0000-0000-000000000001' })
    end.not_to raise_error
  end

  it 'raises with correct error message when fields are empty' do
    expect do
      described_class.build({})
    end.to raise_error(Presentation::Exception::BadRequestException) do |error|
      error_data = JSON.parse(error.message)
      expect(error_data).to eq({ 'id' => ['is missing'] })
    end
  end

  it 'raises with correct error message when fields are empty' do
    expect do
      described_class.build({ id: '00000000000000000000000000000001' })
    end.to raise_error(Presentation::Exception::BadRequestException) do |error|
      error_data = JSON.parse(error.message)
      expect(error_data).to eq({ 'id' => ['is in invalid format'] })
    end
  end

  it 'raises with correct error message when fields are empty' do
    expect do
      described_class.build({ id: '00000000-0000-0000-0000-000000000001', email: 'not-an-email' })
    end.to raise_error(Presentation::Exception::BadRequestException) do |error|
      error_data = JSON.parse(error.message)
      expect(error_data).to eq({ 'email' => ['is in invalid format'] })
    end
  end

  it 'raises BadRequestException when email is invalid format' do
    expect do
      described_class.build({ id: '00000000-0000-0000-0000-000000000001', first_name: 'Taro', last_name: 'Yamada',
                              email: 'not-an-email' })
    end.to raise_error(Presentation::Exception::BadRequestException) do |error|
      error_data = JSON.parse(error.message)
      expect(error_data).to eq({ 'email' => ['is in invalid format'] })
    end
  end

  it 'raises BadRequestException when id is invalid format' do
    expect do
      described_class.build({ id: '00000000000000000000000000000001', first_name: 'Taro', last_name: 'Yamada',
                              email: 'tanaka@gmail.com' })
    end.to raise_error(Presentation::Exception::BadRequestException) do |error|
      error_data = JSON.parse(error.message)
      expect(error_data).to eq({ 'id' => ['is in invalid format'] })
    end
  end
end
