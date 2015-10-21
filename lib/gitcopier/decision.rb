module Gitcopier
  class Decision
    attr_accessor :source, :des
    def initialize(decision, source, des)
      @decision = decision
      @source = source
      @des = des
    end

    def is_copy?
      @decision == 'y'
    end

    def is_follow?
      @decision != 'y' && @decision != 'n'
    end

    def is_not_copy?
      @decision == 'n'
    end

    def to_json(*a)
      {
        decision: @decision,
        source: @source,
        des: @des
      }.to_json(*a)
    end
  end
end
