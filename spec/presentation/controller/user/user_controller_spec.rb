
# frozen_string_literal: true

require_relative '../../../spec_helper'

RSpec.describe Presentation::Controller::User::UserController do
  let(:controller) { described_class.new }

  def valid_create_params
    { first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com' }
  end

  def valid_update_params
    { first_name: 'Jiro', last_name: 'Suzuki', email: 'jiro@example.com' }
  end

  describe '#index' do
    it 'returns all users' do
      # UseCase縺ｮ繝｢繝・け
      mock_use_case = double('GetAllUserUseCase')
      stub_dto1 = double('UserDto', id: '1', first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
      stub_dto2 = double('UserDto', id: '2', first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com')

      # resolve 繝｡繧ｽ繝・ラ繧偵せ繧ｿ繝門喧
      expected_key = 'application.use_case.user.get_all_user_use_case'
      allow(controller).to receive(:resolve)
                             .with(expected_key)
                             .and_return(mock_use_case)

      allow(mock_use_case).to receive(:invoke)
                                .and_return([stub_dto1, stub_dto2])

      # 螳溯｡・      result = controller.index

      # 讀懆ｨｼ
      expect(result).to be_a(Array)
      expect(result.size).to eq(2)
      expect(result.first[:id]).to eq('1')
      expect(result.last[:id]).to eq('2')
    end
  end

  describe '#show' do
    it 'returns a single user' do
      mock_use_case = double('GetDetailUserUseCase')
      stub_dto = double('UserDto', id: '123', first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')

      expected_key = 'application.use_case.user.get_detail_user_use_case'
      allow(controller).to receive(:resolve)
                             .with(expected_key)
                             .and_return(mock_use_case)

      expect(mock_use_case).to receive(:invoke)
                                 .with('123')
                                 .and_return(stub_dto)

      result = controller.show('123')

      expect(result[:id]).to eq('123')
      expect(result[:first_name]).to eq('Taro')
    end

    it 'raises error when id is empty' do
      expect {
        controller.show('')
      }.to raise_error(ArgumentError, '譁・ｭ怜・縺檎ｩｺ縺ｧ縺・)
    end

    it 'raises error when id is nil' do
      expect {
        controller.show(nil)
      }.to raise_error(ArgumentError, '譁・ｭ怜・縺檎ｩｺ縺ｧ縺・)
    end
  end

  describe '#create' do
    it 'creates a new user' do
      mock_use_case = double('CreateUserUseCase')
      stub_dto = double('UserDto', id: '456', first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')

      expected_key = 'application.use_case.user.create_user_use_case'
      allow(controller).to receive(:resolve)
                             .with(expected_key)
                             .and_return(mock_use_case)

      expect(mock_use_case).to receive(:invoke)
                                 .with(instance_of(Application::Dto::User::CreateUserInputDto))
                                 .and_return(stub_dto)

      result = controller.create(valid_create_params)

      expect(result[:id]).to eq('456')
      expect(result[:first_name]).to eq('Taro')
    end

    it 'raises BadRequestException with invalid params' do
      expect {
        controller.create({ first_name: '', last_name: '', email: 'invalid' })
      }.to raise_error(Presentation::Exception::BadRequestException)
    end

    it 'raises BadRequestException with empty params' do
      expect {
        controller.create({})
      }.to raise_error(Presentation::Exception::BadRequestException)
    end
  end

  describe '#update' do
    it 'updates an existing user' do
      mock_use_case = double('UpdateUserUseCase')
      stub_dto = double('UserDto', id: '00000000-0000-0000-0000-000000000001', first_name: 'Updated', last_name: 'Name', email: 'updated@example.com')

      expected_key = 'application.use_case.user.update_user_use_case'
      allow(controller).to receive(:resolve)
                             .with(expected_key)
                             .and_return(mock_use_case)

      expect(mock_use_case).to receive(:invoke) do |input_dto|
        expect(input_dto).to be_instance_of(Application::Dto::User::UpdateUserInputDto)
        expect(input_dto.id).to eq('00000000-0000-0000-0000-000000000001')
        expect(input_dto.first_name).to eq('Jiro')
        stub_dto
      end

      result = controller.update(valid_update_params, '00000000-0000-0000-0000-000000000001')

      expect(result[:id]).to eq('00000000-0000-0000-0000-000000000001')
      expect(result[:first_name]).to eq('Updated')
    end

    it 'merges id into params' do
      mock_use_case = double('UpdateUserUseCase')
      stub_dto = double('UserDto', id: '00000000-0000-0000-0000-000000000001', first_name: 'Test', last_name: 'User', email: 'test@example.com')

      expected_key = 'application.use_case.user.update_user_use_case'
      allow(controller).to receive(:resolve)
                             .with(expected_key)
                             .and_return(mock_use_case)

      expect(mock_use_case).to receive(:invoke) do |input_dto|
        expect(input_dto.id).to eq('00000000-0000-0000-0000-000000000001')
        stub_dto
      end

      controller.update(valid_update_params, '00000000-0000-0000-0000-000000000001')
    end

    it 'raises BadRequestException with invalid id format' do
      expect {
        controller.update(valid_update_params, 'invalid-uuid')
      }.to raise_error(Presentation::Exception::BadRequestException)
    end

    it 'raises BadRequestException with invalid email' do
      expect {
        controller.update({ email: 'not-an-email' }, '00000000-0000-0000-0000-000000000001')
      }.to raise_error(Presentation::Exception::BadRequestException)
    end
  end

  describe '#destroy' do
    it 'raises error when id is empty' do
      expect {
        controller.destroy('')
      }.to raise_error(ArgumentError, '譁・ｭ怜・縺檎ｩｺ縺ｧ縺・)
    end

    it 'raises error when id is nil' do
      expect {
        controller.destroy(nil)
      }.to raise_error(ArgumentError, '譁・ｭ怜・縺檎ｩｺ縺ｧ縺・)
    end

    it 'does not raise error with valid id' do
      expect {
        controller.destroy('00000000-0000-0000-0000-000000000001')
      }.not_to raise_error
    end
  end
end