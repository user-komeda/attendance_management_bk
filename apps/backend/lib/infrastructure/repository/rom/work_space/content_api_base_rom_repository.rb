# frozen_string_literal: true

require_relative '../../../../../config/import'

# rbs_inline: enabled

module Infrastructure
  module Repository
    module Rom
      module WorkSpace
        class ContentApiBaseRomRepository < ROM::Repository[:content_apis]
          include AutoInject['container']
          include Infrastructure::Repository::Rom::RomRepositoryBase

          commands :create, update: :by_pk, delete: :by_pk
        end
      end
    end
  end
end
