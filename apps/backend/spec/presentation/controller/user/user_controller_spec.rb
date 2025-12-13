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
    subject(:result) { controller.index }

    let(:mock_use_case) { instance_double(Application::UseCase::User::GetAllUserUseCase) }
    let(:first_user_dto) do
      instance_double(
        Application::Dto::User::UserDto,
        id: '1', first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com'
      )
    end
    let(:second_user_dto) do
      instance_double(
        Application::Dto::User::UserDto,
        id: '2', first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com'
      )
    end

    before do
      expected_key = 'application.use_case.user.get_all_user_use_case'
      allow(controller).to receive(:resolve).with(expected_key).and_return(mock_use_case)
      allow(mock_use_case).to receive(:invoke).and_return([first_user_dto, second_user_dto])
    end

    it 'returns an array' do
      expect(result).to be_a(Array)
    end

    it 'returns two elements' do
      expect(result.size).to eq(2)
    end

    it 'includes first id' do
      expect(result.first[:id]).to eq('1')
    end

    it 'includes last id' do
      expect(result.last[:id]).to eq('2')
    end
  end

  describe '#show' do
    let(:mock_use_case) { instance_double(Application::UseCase::User::GetDetailUserUseCase) }
    let(:stub_dto) do
      instance_double(
        Application::Dto::User::UserDto,
        id: '123', first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com'
      )
    end
    let(:expected_key) { 'application.use_case.user.get_detail_user_use_case' }

    before do
      allow(controller).to receive(:resolve).with(expected_key).and_return(mock_use_case)
      allow(mock_use_case).to receive(:invoke).and_return(stub_dto)
    end

    it 'invokes use case' do
      controller.show('123')
      expect(mock_use_case).to have_received(:invoke).with('123')
    end

    it 'returns id' do
      result = controller.show('123')
      expect(result[:id]).to eq('123')
    end

    it 'returns first_name' do
      result = controller.show('123')
      expect(result[:first_name]).to eq('Taro')
    end

    it 'raises error when id is empty' do
      expect do
        controller.show('')
      end.to raise_error(ArgumentError)
    end

    it 'raises error when id is nil' do
      expect do
        controller.show(nil)
      end.to raise_error(ArgumentError)
    end
  end

  describe '#update' do
    context 'with valid id and params' do
      subject(:result) { controller.update(valid_update_params, uuid) }

      let(:uuid) { '00000000-0000-0000-0000-000000000001' }
      let(:mock_use_case) { instance_double(Application::UseCase::User::UpdateUserUseCase) }
      let(:stub_dto) do
        instance_double(
          Application::Dto::User::UserDto,
          id: uuid, first_name: 'Updated', last_name: 'Name', email: 'updated@example.com'
        )
      end

      before do
        expected_key = 'application.use_case.user.update_user_use_case'
        allow(controller).to receive(:resolve).with(expected_key).and_return(mock_use_case)
        allow(mock_use_case).to receive(:invoke).and_return(stub_dto)
      end

      it 'returns id' do
        expect(result[:id]).to eq(uuid)
      end

      it 'returns first_name' do
        expect(result[:first_name]).to eq('Updated')
      end
    end

    context 'with spied use case' do
      let(:uuid) { '00000000-0000-0000-0000-000000000001' }
      let(:spy) { instance_spy(Application::UseCase::User::UpdateUserUseCase) }

      before do
        allow(controller).to receive(:resolve)
          .with('application.use_case.user.update_user_use_case')
          .and_return(spy)

        # stub return to avoid UserResponse calling unknown methods on the spy
        allow(spy).to receive(:invoke).and_return(
          instance_double(
            Application::Dto::User::UserDto,
            id: uuid,
            first_name: 'Updated',
            last_name: 'Name',
            email: 'updated@example.com'
          )
        )
      end

      it 'calls use case' do
        controller.update(valid_update_params, uuid)
        expect(spy).to have_received(:invoke)
      end

      it 'sets id on input dto' do
        controller.update(valid_update_params, uuid)
        expect(spy).to have_received(:invoke).with(satisfy { |dto| dto.id == uuid })
      end
    end

    it 'raises BadRequestException with invalid id format' do
      expect do
        controller.update(valid_update_params, 'invalid-uuid')
      end.to raise_error(Presentation::Exception::BadRequestException)
    end

    it 'raises BadRequestException with invalid email' do
      expect do
        controller.update({ email: 'not-an-email' }, '00000000-0000-0000-0000-000000000001')
      end.to raise_error(Presentation::Exception::BadRequestException)
    end
  end

  describe '#destroy' do
    it 'raises error when id is empty' do
      expect do
        controller.destroy('')
      end.to raise_error(ArgumentError)
    end

    it 'raises error when id is nil' do
      expect do
        controller.destroy(nil)
      end.to raise_error(ArgumentError)
    end

    it 'does not raise error with valid id' do
      expect do
        controller.destroy('00000000-0000-0000-0000-000000000001')
      end.not_to raise_error
    end
  end
end
