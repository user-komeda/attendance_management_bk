# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Relations
    class Fields < ROM::Relation[:sql]
      schema(:fields, infer: true) do
        associations do
          belongs_to :content_api
        end
      end

      # @rbs (String content_api_id) -> ROM::Relation[untyped]
      def by_content_api_id(content_api_id)
        where(content_api_id: content_api_id)
      end
    end
  end
end
