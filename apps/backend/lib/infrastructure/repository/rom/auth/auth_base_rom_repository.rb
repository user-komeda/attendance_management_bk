# frozen_string_literal: true

# rbs_inline: enabled

require_relative '../../../../../config/import'

module Infrastructure
  module Repository
    module Rom
      module Auth
        class AuthBaseRomRepository < ROM::Repository[:auth_users]
          include AutoInject['container']
          include Infrastructure::Repository::Rom::RomRepositoryBase
        end
      end
    end
  end
end
