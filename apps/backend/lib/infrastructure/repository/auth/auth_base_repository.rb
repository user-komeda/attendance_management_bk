# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module Auth
      class AuthBaseRepository < RepositoryBase
        ROM_REPOSITORY_KEY = Constant::ContainerKey::RomRepositoryKey::AUTH_ROM_REPOSITORY[:auth].key.freeze
      end
    end
  end
end
