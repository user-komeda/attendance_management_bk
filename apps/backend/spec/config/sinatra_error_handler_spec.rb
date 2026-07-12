# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SinatraErrorHandler do
  let(:handler) do
    Class.new do
      include SinatraErrorHandler
      include ResponseHelper

      def respond_with_error(error)
        { error: error.message }
      end
    end.new
  end

  describe '#handle_api_error' do
    context 'when error has backtrace' do
      let(:error) do
        err = AppException::ApiError.new(
          message: 'test error',
          error_code: Constant::Errors::Codes::INTERNAL_SERVER_ERROR
        )
        allow(err).to receive(:backtrace).and_return(%w[line1 line2])
        err
      end

      it 'handles error without raising' do
        expect { handler.handle_api_error(error) }.not_to raise_error
      end
    end

    context 'when error has no backtrace' do
      let(:error) do
        err = AppException::ApiError.new(
          message: 'test error',
          error_code: Constant::Errors::Codes::INTERNAL_SERVER_ERROR
        )
        allow(err).to receive(:backtrace).and_return(nil)
        err
      end

      it 'handles error without raising' do
        expect { handler.handle_api_error(error) }.not_to raise_error
      end
    end
  end

  describe '#handle_standard_error' do
    context 'when error has backtrace' do
      let(:error) do
        err = StandardError.new('standard error')
        allow(err).to receive(:backtrace).and_return(%w[line1 line2])
        err
      end

      it 'handles error without raising' do
        expect { handler.handle_standard_error(error) }.not_to raise_error
      end
    end

    context 'when error has no backtrace' do
      let(:error) do
        err = StandardError.new('standard error')
        allow(err).to receive(:backtrace).and_return(nil)
        err
      end

      it 'handles error without raising' do
        expect { handler.handle_standard_error(error) }.not_to raise_error
      end
    end
  end
end
