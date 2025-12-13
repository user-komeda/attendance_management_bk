# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Entity
    module Auth
      class AuthUserEntity < BaseEntity
        # @rbs!
        #   attr_reader id: String
        #   attr_reader user_id: String
        #   attr_reader email: String
        #   attr_reader provider: String
        #   attr_reader password_digest: String
        #   attr_reader last_login_at: Time?
        #   attr_reader is_active: bool
        attribute :id, ROM::Types::String
        attribute :user_id, ROM::Types::String
        attribute :email, ROM::Types::String
        attribute :provider, ROM::Types::String
        attribute :password_digest, ROM::Types::String
        attribute :last_login_at, ROM::SQL::Types::DateTime.optional
        attribute :is_active, ROM::Types::Bool

        # @rbs () -> ::Domain::Entity::Auth::AuthUserEntity
        def to_domain
          ::Domain::Entity::Auth::AuthUserEntity.build_with_id(
            {
              id: id,
              user_id: user_id,
              email: email,
              password: password_digest,
              provider: provider,
              last_login_at: last_login_at,
              is_active: is_active
            }
          )
        end

        # @rbs (untyped struct) -> ::Domain::Entity::Auth::AuthUserEntity
        def self.struct_to_domain(struct)
          auth_user_entity = new(
            id: struct.id,
            user_id: struct.user_id,
            email: struct.email,
            password_digest: struct.password_digest,
            provider: struct.provider,
            last_login_at: struct.last_login_at,
            is_active: struct.is_active
          )
          auth_user_entity.to_domain
        end
      end
    end
  end
end
