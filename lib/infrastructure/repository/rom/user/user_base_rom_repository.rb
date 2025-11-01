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

          # @rbs @container: untyped

          # @rbs () -> ROM::Relation
          # def users: () -> ROM::Relation

          # @rbs (untyped) -> untyped
          # def create: (untyped) -> untyped

          # @rbs (untyped, untyped) -> untyped
          # def update: (untyped, untyped) -> untyped

          # @rbs (untyped) -> untyped
          # def delete: (untyped) -> untyped
        end
      end
    end
  end
end