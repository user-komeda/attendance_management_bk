# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module ValueObject
    class BaseValueObject
      # @rbs (*untyped args) -> BaseValueObject
      def self.build(*args)
        raise NotImplementedError, 'Subclasses must implement .build'
      end

      # 遲我ｾ｡諤ｧ縺ｯ蝓ｺ蠎輔け繝ｩ繧ｹ縺ｧ蜈ｱ騾壼喧
      # @rbs (untyped other) -> bool
      def ==(other)
        self.class == other.class && values == other.values
      end

      # @rbs (untyped other) -> bool
      def eql?(other)
        self == other
      end

      # @rbs () -> Integer
      def hash
        values.hash
      end

      # 繧ｵ繝悶け繝ｩ繧ｹ縺ｧ豈碑ｼ・ｯｾ雎｡蛟､繧定ｿ斐☆・医う繝ｳ繧ｹ繧ｿ繝ｳ繧ｹ繝｡繧ｽ繝・ラ・・      # @rbs () -> Array[untyped]
      def values
        raise NotImplementedError, 'Subclasses must implement #values'
      end

      # @rbs (*untyped args) -> void
      def self.validate!(*args)
        raise NotImplementedError, 'Subclasses must implement .validate!'
      end
    end
  end
end
