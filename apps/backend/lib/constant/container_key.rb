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
    end

    module ServiceKey
      Service = Struct.new(:key, keyword_init: true)

      # @rbs SERVICE: Hash[Symbol, Service]
      SERVICE = {
        user: Service.new(
          key: 'domain.service.user.user_service'
        )
      }.freeze
    end

    module DomainRepositoryKey
      DomainRepository = Struct.new(:key, keyword_init: true)

      # @rbs DOMAIN_REPOSITORY: Hash[Symbol, DomainRepository]
      DOMAIN_REPOSITORY = {
        user: DomainRepository.new(
          key: 'domain.repository.user.user_repository'
        )
      }.freeze
    end

    module RepositoryKey
      Repository = Struct.new(:key, keyword_init: true)

      # @rbs REPOSITORY: Hash[Symbol, Repository]
      REPOSITORY = {
        user: Repository.new(
          key: 'infrastructure.repository.user.user_repository'
        )
      }.freeze
    end

    module RomRepositoryKey
      RomRepository = Struct.new(:key, keyword_init: true)

      # @rbs ROM_REPOSITORY: Hash[Symbol, RomRepository]
      ROM_REPOSITORY = {
        user: RomRepository.new(
          key: 'infrastructure.repository.rom.user.user_rom_repository'
        )
      }.freeze
    end
  end
end
