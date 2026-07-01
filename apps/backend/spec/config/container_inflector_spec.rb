# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ContainerInflector do
  subject(:inflector) { described_class.new }

  describe '#camelize' do
    it 'converts Api part to API' do
      expect(inflector.camelize('Api')).to eq('API')
    end

    it 'keeps non-Api parts unchanged' do
      expect(inflector.camelize('work_space')).to eq('WorkSpace')
    end

    it 'converts API string in parts' do
      result = inflector.camelize('content_api')
      expect(result).to be_a(String)
    end

    it 'converts API back to Api in gsub' do
      result = inflector.camelize('my_api_service')
      expect(result).to be_a(String)
    end

    it 'handles module path with multiple parts' do
      result = inflector.camelize('work_space/member_ship')
      expect(result).to eq('WorkSpace::MemberShip')
    end
  end
end
