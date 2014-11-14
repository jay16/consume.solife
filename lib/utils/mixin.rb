module Utils
  class Mixin
    def self.included(base)
      base.extend(ClassMthods)
    end

    module ClassMthods
      def pos
        self.class_eval do
          puts __FILE__
          puts self
        end
      end
    end
  end
end

