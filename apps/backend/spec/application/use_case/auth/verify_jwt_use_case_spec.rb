# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::Auth::VerifyJwtUseCase do
  subject(:use_case) { described_class.new }

  let(:secret) { 'test_secret' }
  let(:bff_secret) { 'bff_test_secret' }
  let(:issuer) { 'test_issuer' }
  let(:audience) { 'test_audience' }

  before do
    allow(AppEnv).to receive(:get).and_return(
      'JWT_SECRET' => secret,
      'BFF_JWT_SECRET' => bff_secret,
      'JWT_ISSUER' => issuer,
      'JWT_AUDIENCE' => audience
    )
  end

  def encode_token(payload, key)
    JWT.encode(payload, key, 'HS256')
  end

  def valid_user_payload
    {
      'sub' => '00000000-0000-0000-0000-000000000001',
      'typ' => 'access_token',
      'exp' => Time.now.to_i + 3600,
      'iss' => issuer,
      'aud' => audience
    }
  end

  def valid_bff_payload
    {
      'typ' => 'bff_assertion',
      'exp' => Time.now.to_i + 3600,
      'iss' => issuer,
      'aud' => audience
    }
  end

  def build_env
    {
      'JWT_SECRET' => secret,
      'BFF_JWT_SECRET' => bff_secret,
      'JWT_ISSUER' => issuer,
      'JWT_AUDIENCE' => audience
    }
  end

  def build_use_case_with_stub
    use_case_with_stub = described_class.new
    allow(use_case_with_stub).to receive(:secret_for).and_return(secret)
    allow(use_case_with_stub).to receive(:validate_expiration)
    allow(use_case_with_stub).to receive(:validate_type).and_call_original
    use_case_with_stub
  end

  describe '#invoke' do
    context 'when type is :user and token is valid' do
      let(:token) { encode_token(valid_user_payload, secret) }

      it 'returns AuthOutputDto with id and user_id' do
        result = use_case.invoke(token: token, type: :user)
        expect(result).to have_attributes(
          id: '00000000-0000-0000-0000-000000000001',
          user_id: '00000000-0000-0000-0000-000000000001'
        )
      end
    end

    context 'when type is :bff and token is valid' do
      let(:token) { encode_token(valid_bff_payload, bff_secret) }

      it 'returns true' do
        result = use_case.invoke(token: token, type: :bff)
        expect(result).to be true
      end
    end

    context 'when token is invalid (DecodeError)' do
      it 'raises InvalidToken' do
        expect { use_case.invoke(token: 'invalid.token.here', type: :user) }
          .to raise_error(Application::Exception::InvalidToken)
      end
    end

    context 'when type is unknown' do
      it 'raises InvalidToken' do
        expect { use_case.invoke(token: 'any', type: :unknown) }
          .to raise_error(Application::Exception::InvalidToken)
      end
    end

    context 'when exp is missing' do
      let(:payload) do
        valid_user_payload.merge('exp' => nil)
      end

      it 'raises InvalidToken' do
        allow(JWT).to receive(:decode).and_return([payload, {}])
        expect { use_case.invoke(token: 'any', type: :user) }
          .to raise_error(Application::Exception::InvalidToken)
      end
    end

    context 'when token is expired' do
      let(:payload) do
        valid_user_payload.merge('exp' => Time.now.to_i - 1)
      end

      it 'raises TokenExpired' do
        allow(JWT).to receive(:decode).and_return([payload, {}])
        expect { use_case.invoke(token: 'any', type: :user) }
          .to raise_error(Application::Exception::TokenExpired)
      end
    end

    context 'when user token has wrong typ' do
      let(:payload) do
        valid_user_payload.merge('typ' => 'wrong_type')
      end

      it 'raises InvalidToken' do
        allow(JWT).to receive(:decode).and_return([payload, {}])
        expect { use_case.invoke(token: 'any', type: :user) }
          .to raise_error(Application::Exception::InvalidToken)
      end
    end

    context 'when user token has empty sub' do
      let(:payload) do
        valid_user_payload.merge('sub' => '')
      end

      it 'raises InvalidToken' do
        allow(JWT).to receive(:decode).and_return([payload, {}])
        expect { use_case.invoke(token: 'any', type: :user) }
          .to raise_error(Application::Exception::InvalidToken)
      end
    end

    context 'when bff token has wrong typ' do
      let(:payload) do
        valid_bff_payload.merge('typ' => 'wrong_type')
      end

      it 'raises InvalidToken' do
        allow(JWT).to receive(:decode).and_return([payload, {}])
        expect { use_case.invoke(token: 'any', type: :bff) }
          .to raise_error(Application::Exception::InvalidToken)
      end
    end

    context 'when validate_type is called with unknown type' do
      it 'raises InvalidToken from validate_type else branch' do
        allow(JWT).to receive(:decode).and_return([valid_user_payload, {}])
        expect { use_case.invoke(token: encode_token(valid_user_payload, secret), type: :unknown) }
          .to raise_error(Application::Exception::InvalidToken)
      end
    end

    context 'when secret_for is called with unknown type' do
      it 'raises InvalidToken from secret_for else branch' do
        allow(JWT).to receive(:decode).and_call_original
        expect { use_case.invoke(token: encode_token(valid_user_payload, secret), type: :unknown) }
          .to raise_error(Application::Exception::InvalidToken)
      end
    end

    context 'when validate_type is called with unknown type after decode succeeds' do
      it 'raises InvalidToken from validate_type else branch' do
        allow(JWT).to receive(:decode).and_return([valid_user_payload.merge('typ' => 'access_token'), {}])
        allow(AppEnv).to receive(:get).and_return(build_env)
        use_case_with_stub = build_use_case_with_stub
        expect { use_case_with_stub.send(:validate_type, valid_user_payload, :unknown) }
          .to raise_error(Application::Exception::InvalidToken, 'invalid token type')
      end
    end
  end
end
