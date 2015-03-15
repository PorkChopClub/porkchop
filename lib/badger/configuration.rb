module Badger
  class Configuration
    attr_reader :registry

    def initialize
      @registry = ActiveSupport::HashWithIndifferentAccess.new
    end

    def varieties
      @registry.keys
    end
  end
end
