require "badger/configuration"
require "badger/reload"
require "badger/base"

module Badger
  class Proxy
    def badge(variety, &block)
      Badger.registry[variety] = Base.new.tap do |badge|
        badge.instance_eval(&block)
      end
    end
  end

  class << self
    delegate :registry, :varieties, to: :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.define(&block)
    Proxy.new.instance_eval(&block)
  end

  def self.determine_rank(variety, player:)
    return 0 unless player
    Badger.registry[variety].rank_proc.call(player)
  end

  def self.earned?(variety, player:)
    return false unless player
    Badger.registry[variety].condition_proc.call(player)
  end
end
