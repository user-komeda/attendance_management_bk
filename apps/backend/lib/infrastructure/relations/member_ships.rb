# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Relations
    # @rbs!
    #   interface _Relation
    #     def where: (*untyped) -> self
    #     def pluck: (*untyped) -> Array[untyped]
    #   end
    class MemberShips < ROM::Relation[:sql]
      # @rbs! include _Relation
      schema(:member_ships, infer: true) do
        associations do
          belongs_to :user
          belongs_to :work_space
        end
      end

      # @rbs (String user_id) -> ROM::Relation[untyped]
      def by_user_id(user_id)
        where(user_id: user_id)
      end

      # @rbs (String work_space_id) -> ROM::Relation[untyped]
      def by_work_space_id(work_space_id)
        where(work_space_id: work_space_id)
      end

      # @rbs () -> ROM::Relation[untyped]
      def plunk_work_space_id_and_status
        pluck(:work_space_id, :status)
      end
    end
  end
end
