# frozen_string_literal: true

# rbs_inline: enabled

module Constant
  module ContainerKey
    module ApplicationKey
      UseCase = Struct.new(:key, keyword_init: true)

      # @rbs USER_USE_CASE: Hash[Symbol, UseCase]
      USER_USE_CASE = {
        get_all: UseCase.new(
          key: 'application.use_case.user.get_all_user_use_case'
        ),
        get_detail: UseCase.new(
          key: 'application.use_case.user.get_detail_user_use_case'
        ),
        create_user: UseCase.new(
          key: 'application.use_case.user.create_user_use_case'
        ),
        update_user: UseCase.new(
          key: 'application.use_case.user.update_user_use_case'
        )
      }.freeze

      # @rbs USER_USE_CASE: Hash[Symbol, UseCase]
      AUTH_USE_CASE = {
        signin: UseCase.new(
          key: 'application.use_case.auth.signin_use_case'
        ),
        signup: UseCase.new(
          key: 'application.use_case.auth.signup_use_case'
        )
      }.freeze
    end

    module ServiceKey
      Service = Struct.new(:key, keyword_init: true)

      # @rbs SERVICE: Hash[Symbol, Service]
      USER_SERVICE = {
        user: Service.new(
          key: 'domain.service.user.user_service'
        )
      }.freeze

      # @rbs SERVICE: Hash[Symbol, Service]
      AUTH_SERVICE = {
        auth: Service.new(
          key: 'domain.service.auth.auth_service'
        )
      }.freeze
    end

    module DomainRepositoryKey
      DomainRepository = Struct.new(:key, keyword_init: true)

      # @rbs DOMAIN_REPOSITORY: Hash[Symbol, DomainRepository]
      USER_DOMAIN_REPOSITORY = {
        user: DomainRepository.new(
          key: 'domain.repository.user.user_repository'
        )
      }.freeze

      # @rbs DOMAIN_REPOSITORY: Hash[Symbol, DomainRepository]
      AUTH_DOMAIN_REPOSITORY = {
        auth: DomainRepository.new(
          key: 'domain.repository.auth.auth_repository'
        )
      }.freeze
    end

    module RepositoryKey
      Repository = Struct.new(:key, keyword_init: true)

      # @rbs REPOSITORY: Hash[Symbol, repository]
      USER_REPOSITORY = {
        user: Repository.new(
          key: 'infrastructure.repository.user.user_repository'
        )
      }.freeze

      # @rbs REPOSITORY: Hash[Symbol, repository]
      AUTH_REPOSITORY = {
        auth: Repository.new(
          key: 'infrastructure.repository.auth.auth_repository'
        )
      }.freeze
    end

    module RomRepositoryKey
      RomRepository = Struct.new(:key, keyword_init: true)

      # @rbs ROM_REPOSITORY: Hash[Symbol, RomRepository]
      USER_ROM_REPOSITORY = {
        user: RomRepository.new(
          key: 'infrastructure.repository.rom.user.user_rom_repository'
        )
      }.freeze

      # @rbs ROM_REPOSITORY: Hash[Symbol, RomRepository]
      AUTH_ROM_REPOSITORY = {
        auth: RomRepository.new(
          key: 'infrastructure.repository.rom.auth.auth_rom_repository'
        )
      }.freeze
    end
  end
end
