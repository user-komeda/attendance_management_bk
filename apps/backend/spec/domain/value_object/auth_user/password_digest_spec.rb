# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::ValueObject::AuthUser::PasswordDigest do
  let(:raw) { 'Abcdefg1' }
  let(:hashed) { '$2a$12$abcdefghijklmnopqrstuvwxabcdefghijklmnopqrstu' }

  describe '.build' do
    context 'with a raw password' do
      it 'validates and returns hashed value using PasswordEncryptor' do
        allow(PasswordEncryptor).to receive(:digest).with(raw).and_return(hashed)

        vo = described_class.build(raw)
        expect(vo).to(satisfy { |v| v.is_a?(described_class) && v.value == hashed })
      end

      it 'raises InvalidPasswordError when password is nil' do
        expect { described_class.build(nil) }
          .to raise_error(Domain::Exception::InvalidPasswordError, 'パスワードは必須です')
      end

      it 'raises InvalidPasswordError when password is empty' do
        expect { described_class.build('') }
          .to raise_error(Domain::Exception::InvalidPasswordError, 'パスワードは必須です')
      end

      it 'raises when shorter than 8 chars' do
        expect { described_class.build('Abcde1') }
          .to raise_error(Domain::Exception::InvalidPasswordError, '8文字以上入力してください')
      end

      it 'raises when missing uppercase' do
        expect { described_class.build('abcdefg1') }
          .to raise_error(Domain::Exception::InvalidPasswordError, '英大文字を1文字以上含めてください')
      end

      it 'raises when missing lowercase' do
        expect { described_class.build('ABCDEFG1') }
          .to raise_error(Domain::Exception::InvalidPasswordError, '英小文字を1文字以上含めてください')
      end

      it 'raises when missing digit' do
        expect { described_class.build('Abcdefgh') }
          .to raise_error(Domain::Exception::InvalidPasswordError, '数字を含めてください')
      end
    end

    context 'with an already hashed password' do
      it 'skips validate! and digest when value looks like bcrypt' do
        hashed_bcrypt = '$2a$12$9y8itBS.pQqrZ/9P8k8LseGiBT7i53UdQThpjhGtO3tYf9ynTIbCa'
        vo = described_class.build(hashed_bcrypt)
        expect(vo.value).to eq(hashed_bcrypt)
      end
    end
  end

  describe '#values' do
    it 'returns [value]' do
      allow(PasswordEncryptor).to receive(:digest).and_return('$2a$12$abcdefghijkabcdefghijkabcdabcdefghijkabcd')
      vo = described_class.build('Abcdefg1')
      expect(vo.values).to eq([vo.value])
    end
  end
end
