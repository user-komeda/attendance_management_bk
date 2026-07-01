# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RouteHelper do
  let(:helper) do
    Class.new do
      include RouteHelper
    end.new
  end

  describe '#validate_id!' do
    context 'when id_format is nil' do
      it 'returns without raising' do
        expect { helper.send(:validate_id!, 'any-id', nil) }.not_to raise_error
      end
    end

    context 'when id matches format' do
      it 'returns without raising' do
        expect { helper.send(:validate_id!, 'valid-slug', /\A[a-z0-9-]+\z/) }.not_to raise_error
      end
    end

    context 'when id does not match format' do
      it 'raises BadRequestException' do
        expect { helper.send(:validate_id!, 'INVALID', /\A[a-z0-9-]+\z/) }
          .to raise_error(Presentation::Exception::BadRequestException, 'Invalid id format')
      end
    end
  end

  describe '#build_base_path' do
    it 'returns empty string when resource_name is empty and parent is nil' do
      result = helper.send(:build_base_path, resource_name: '', parent: nil)

      expect(result).to eq('')
    end
  end

  describe '#define_route' do
    it 'raises when action is not defined' do
      expect { helper.send(:define_route, :unknown, nil) }.to raise_error(NoMatchingPatternError)
    end
  end
end
