module Achievements
  module Dsl
    @registry = ActiveSupport::HashWithIndifferentAccess.new

    def self.registry
      @registry
    end

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def achievements(&block)
        Proxy.new.instance_eval(&block)
      end

      def varieties
        Dsl.registry.keys
      end
    end

    class Proxy
      def achievement(variety, *args, &block)
        Dsl.registry[variety] = Base.new(*args).tap do |achievement|
          achievement.instance_eval(&block)
        end
      end
    end

    def achieved?
      return false unless player
      Dsl.registry[variety].condition_proc.call(player)
    end
  end
end
