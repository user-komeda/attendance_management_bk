# frozen_string_literal: true
module ContainerKey
  module ApplicationKey
    ROOT_USE_CASE = {
      key: "application.use_case.root.get_all_use_case",
      invoker: "get_all_use_case"
    }

    def self.key(name)
      const_get(name)[:key]
    end

    def self.invoker(name)
      const_get(name)[:invoker]
    end
  end
  module ServiceKey
    ROOT_SERVICE = {
      key: "domain.service.root.root_service",
      caller: "root_service",
      method: {
        get_all: "get_all",
        get_Detail: "get_Detail",
      },
    }

    def self.key(name)
      const_get(name)[:key]
    end

    def self.caller(name)
      const_get(name)[:caller]
    end

    def self.method(name, method)
      const_get(name)[:method][method]
    end
  end
  module DomainRepository
    DOMAIN_REPOSITORY = {
      key: "domain.repository.root.root_repository",
      caller: "root_repository",
      method: {
        get_all: "get_all",
        get_detail: "get_detail",
      },
      repositoryMethod:{
        get_all:"get_all",
        get_detail: "get_detail"
      }
    }

    def self.key(name)
      const_get(name)[:key]
    end

    def self.caller(name)
      const_get(name)[:caller]
    end

    def self.method(name, method)
      const_get(name)[:method][method]
    end

    def self.repository_method(name, repository_method)
      const_get(name)[:repositoryMethod][repository_method]
    end
  end
  module Repository
    REPOSITORY = {
      key: "infrastructure.repository.root.root_repository",
      caller: "root_repository",
      method: {
        get_all: "get_all",
        get_detail: "get_detail",
      },
    }
    def self.key(name)
      const_get(name)[:key]
    end
  end
end