# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Entity
    module WorkSpace
      class MemberShipsEntity < DomainEntity
        ID = ::Domain::ValueObject::IdentityId.freeze
        ROLE = ::Domain::ValueObject::WorkSpace::Role.freeze
        STATUS = ::Domain::ValueObject::WorkSpace::Status.freeze

        # rubocop:disable all
        attr_reader :id #: ::Domain::ValueObject::IdentityId
        attr_reader :user_id #: ::Domain::ValueObject::IdentityId
        attr_reader :work_space_id #: ::Domain::ValueObject::IdentityId
        attr_reader :role #: ::Domain::ValueObject::WorkSpace::Role?
        attr_reader :status #: ::Domain::ValueObject::WorkSpace::Status?
        # rubocop:enable all

        # rubocop:disable Layout/LineLength
        # @rbs (user_id: ::Domain::ValueObject::IdentityId, work_space_id: ::Domain::ValueObject::IdentityId, role: ::Domain::ValueObject::WorkSpace::Role?, status: ::Domain::ValueObject::WorkSpace::Status?, ?id: ::Domain::ValueObject::IdentityId?) -> void
        # rubocop:enable Layout/LineLength
        def initialize(
          user_id:,
          work_space_id:,
          role: nil,
          status: nil,
          id: nil
        )
          super()
          @id = id
          @work_space_id = work_space_id
          @user_id = user_id
          @role = role
          @status = status
        end

        # @rbs (first_name: String?, last_name: String?, email: String?) -> void
        # def change(first_name:, last_name:, email:)
        #   if UtilMethod.nil_or_empty?(first_name) &&
        #      UtilMethod.nil_or_empty?(last_name) &&
        #      UtilMethod.nil_or_empty?(email)
        #     return
        #   end
        #
        #   new_first_name = UtilMethod.nil_or_empty?(first_name) ? user_name.first_name : first_name
        #
        #   new_last_name = UtilMethod.nil_or_empty?(last_name) ? user_name.last_name : last_name
        #
        #   new_email = UtilMethod.nil_or_empty?(email) ? self.email.value : email
        #
        #   @user_name = ::Domain::ValueObject::User::UserName.build(new_first_name, new_last_name)
        #   @email = ::Domain::ValueObject::User::UserEmail.build(new_email)
        # end

        # @rbs (user_id: String, work_space_id: String, role: String?, status: String?) -> MemberShipsEntity
        def self.build(user_id:, work_space_id:, role: nil, status: nil)
          new(
            user_id: ID.build(user_id),
            work_space_id: ID.build(work_space_id),
            role: ROLE.build(UtilMethod.nil_or_empty?(role) ? 'owner' : role),
            status: STATUS.build(UtilMethod.nil_or_empty?(status) ? 'active' : status)
          )
        end

        # @rbs (id: String, user_id: String, work_space_id: String, role: String, status: String) -> MemberShipsEntity
        def self.build_with_id(id:, user_id:, work_space_id:, role:, status:)
          new(
            id: ID.build(id),
            user_id: ID.build(user_id),
            work_space_id: ID.build(work_space_id),
            role: ROLE.build(role),
            status: STATUS.build(status)
          )
        end
      end
    end
  end
end
