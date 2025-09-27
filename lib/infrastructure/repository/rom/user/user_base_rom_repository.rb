# frozen_string_literal: true

require_relative '../../../../../config/import'

module Infrastructure
  module Repository
    module Rom
      module User
        class UserBaseRomRepository < ROM::Repository[:users]
          include AutoInject['container']
          include Infrastructure::Repository::Rom::RomRepositoryBase
          commands :create, update: :by_pk, delete: :by_pk
        end
      end
    end
  end
end
