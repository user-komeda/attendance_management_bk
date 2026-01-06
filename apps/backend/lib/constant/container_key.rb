# frozen_string_literal: true

# rbs_inline: enabled

module Constant
  module ContainerKey
    # @rbs Key = Struct.new(:key, keyword_init: true)
    Key = Struct.new(:key, keyword_init: true)

    module ApplicationKey
      # @rbs USER_USE_CASE: Hash[Symbol, Key]
      USER_USE_CASE = {
        get_all: Key.new(key: 'application.use_case.user.get_all_user_use_case'),
        get_detail: Key.new(key: 'application.use_case.user.get_detail_user_use_case'),
        create_user: Key.new(key: 'application.use_case.user.create_user_use_case'),
        update_user: Key.new(key: 'application.use_case.user.update_user_use_case')
      }.freeze

      # @rbs AUTH_USE_CASE: Hash[Symbol, Key]
      AUTH_USE_CASE = {
        signin: Key.new(key: 'application.use_case.auth.signin_use_case'),
        signup: Key.new(key: 'application.use_case.auth.signup_use_case'),
        verify_jwt: Key.new(key: 'application.use_case.auth.verify_jwt_use_case')
      }.freeze

      # @rbs WORK_SPACE_USE_CASE: Hash[Symbol, Key]
      WORK_SPACE_USE_CASE = {
        get_all: Key.new(key: 'application.use_case.work_space.get_all_work_space_use_case'),
        get_detail: Key.new(key: 'application.use_case.work_space.get_detail_work_space_use_case'),
        create_work_space: Key.new(key: 'application.use_case.work_space.create_work_space_use_case'),
        update_work_space: Key.new(key: 'application.use_case.work_space.update_work_space_use_case'),
        delete_work_space: Key.new(key: 'application.use_case.work_space.delete_work_space_use_case')
      }.freeze
    end

    # ドメインサービス層のキー
    module ServiceKey
      # @rbs USER_SERVICE: Hash[Symbol, Key]
      USER_SERVICE = {
        user: Key.new(key: 'domain.service.user.user_service')
      }.freeze

      # @rbs AUTH_SERVICE: Hash[Symbol, Key]
      AUTH_SERVICE = {
        auth: Key.new(key: 'domain.service.auth.auth_service')
      }.freeze

      # @rbs WORK_SPACE_SERVICE: Hash[Symbol, Key]
      WORK_SPACE_SERVICE = {
        work_space: Key.new(key: 'domain.service.work_space.work_space_service'),
        member_ships: Key.new(key: 'domain.service.work_space.member_ships_service')
      }.freeze
    end

    # ドメインリポジトリ（Interface）のキー
    module DomainRepositoryKey
      # @rbs USER_DOMAIN_REPOSITORY: Hash[Symbol, Key]
      USER_DOMAIN_REPOSITORY = {
        user: Key.new(key: 'domain.repository.user.user_repository')
      }.freeze

      # @rbs AUTH_DOMAIN_REPOSITORY: Hash[Symbol, Key]
      AUTH_DOMAIN_REPOSITORY = {
        auth: Key.new(key: 'domain.repository.auth.auth_repository')
      }.freeze

      # @rbs WORK_SPACE_DOMAIN_REPOSITORY: Hash[Symbol, Key]
      WORK_SPACE_DOMAIN_REPOSITORY = {
        work_space: Key.new(key: 'domain.repository.work_space.work_space_repository'),
        member_ships: Key.new(key: 'domain.repository.work_space.member_ships_repository')
      }.freeze
    end

    # インフラストラクチャ層（Repository実装）のキー
    module RepositoryKey
      # @rbs USER_REPOSITORY: Hash[Symbol, Key]
      USER_REPOSITORY = {
        user: Key.new(key: 'infrastructure.repository.user.user_repository')
      }.freeze

      # @rbs AUTH_REPOSITORY: Hash[Symbol, Key]
      AUTH_REPOSITORY = {
        auth: Key.new(key: 'infrastructure.repository.auth.auth_repository')
      }.freeze

      # @rbs WORK_SPACE_REPOSITORY: Hash[Symbol, Key]
      WORK_SPACE_REPOSITORY = {
        work_space: Key.new(key: 'infrastructure.repository.work_space.work_space_repository'),
        member_ships: Key.new(key: 'infrastructure.repository.work_space.member_ships_repository')
      }.freeze
    end

    # ROM (ROM-rb) リポジトリのキー
    module RomRepositoryKey
      # @rbs USER_ROM_REPOSITORY: Hash[Symbol, Key]
      USER_ROM_REPOSITORY = {
        user: Key.new(key: 'infrastructure.repository.rom.user.user_rom_repository')
      }.freeze

      # @rbs AUTH_ROM_REPOSITORY: Hash[Symbol, Key]
      AUTH_ROM_REPOSITORY = {
        auth: Key.new(key: 'infrastructure.repository.rom.auth.auth_rom_repository')
      }.freeze

      # @rbs WORK_SPACE_ROM_REPOSITORY: Hash[Symbol, Key]
      WORK_SPACE_ROM_REPOSITORY = {
        work_space: Key.new(key: 'infrastructure.repository.rom.work_space.work_space_rom_repository'),
        member_ships: Key.new(key: 'infrastructure.repository.rom.work_space.member_ships_rom_repository')
      }.freeze
    end
  end
end
