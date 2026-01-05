# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Relations
    class WorkSpace < ROM::Relation[:sql]
      schema(:work_spaces, infer: true) do
        associations do
          has_many :member_ships
        end
      end

      # @rbs (Array[String] workspace_ids) -> ROM::Relation[untyped]
      def by_ids(workspace_ids)
        where(id: workspace_ids)
      end

      # @rbs (String slug) -> ROM::Relation[untyped]
      def by_slug(slug)
        where(slug: slug)
      end
    end
  end
end
