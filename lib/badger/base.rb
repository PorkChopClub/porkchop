module Badger
  class Base
    attr_reader :condition_proc, :rank_proc

    def ranks(ranks = [])
      @ranks ||= ranks
    end

    def condition(&block)
      @condition_proc = block
    end

    def calculate_rank(&block)
      @rank_proc = block
    end
  end
end

