module Achievements
  class Base
    attr_reader :condition_proc

    def condition(&block)
      @condition_proc = block
    end
  end
end

