# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Relations
    class ContentApis < ROM::Relation[:sql]
      schema(:content_apis, infer: true) do
        associations do
          belongs_to :work_space
          has_many :fields
        end
      end

      # @rbs (String work_space_id) -> ROM::Relation[untyped]
      def by_work_space_id(work_space_id)
        where(work_space_id: work_space_id)
      end
    end
  end
end
