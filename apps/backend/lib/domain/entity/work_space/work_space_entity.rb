# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Entity
    module WorkSpace
      class WorkSpaceEntity < DomainEntity
        ID = ::Domain::ValueObject::IdentityId.freeze

        # rubocop:disable all
        attr_reader :id #: ::Domain::ValueObject::IdentityId
        attr_reader :name #: String
        attr_reader :slug #: String
        # rubocop:enable all

        # @rbs (name: String, slug: String, ?id: ::Domain::ValueObject::IdentityId?) -> void
        def initialize(name:, slug:, id: nil)
          super()
          @id = id
          @name = name
          @slug = slug
        end

        # @rbs (change_name: String?, change_slug: String?) -> void
        def change(change_name:, change_slug:)
          change_name_empty = UtilMethod.nil_or_empty?(change_name)
          change_slug_empty = UtilMethod.nil_or_empty?(change_slug)

          return if change_name_empty && change_slug_empty

          new_name = change_name_empty ? name : change_name

          new_slug = change_slug_empty ? slug : change_slug

          @name = new_name
          @slug = new_slug
        end

        # @rbs (name: String, slug: String) -> WorkSpaceEntity
        def self.build(name:, slug:)
          new(
            name: name,
            slug: slug
          )
        end

        # @rbs (id: String, name: String, slug: String) -> WorkSpaceEntity
        def self.build_with_id(id:, name:, slug:)
          new(
            id: ID.build(id),
            name: name,
            slug: slug
          )
        end
      end
    end
  end
end
