# frozen_string_literal: true

module Domain
  module ValueObject
    class BaseValueObject
      def self.build(*args)
        raise NotImplementedError, 'Subclasses must implement .build'
      end

      # 等価性は基底クラスで共通化
      def ==(other)
        self.class == other.class && values == other.values
      end

      def eql?(other)
        self == other
      end

      def hash
        values.hash
      end

      class << self
        def self.validate!(*args)
          raise NotImplementedError, 'Subclasses must implement .validate'
        end

        # サブクラスで比較対象値を返す
        def values
          raise NotImplementedError, 'Subclasses must implement #values'
        end
      end
    end
  end
end
