module BKMG
  class Base 
    class << self
      UNIT_SEQ = %w(B K M G)
      # 1 B = 1 byte = 8 bit 
      # 1 KB = 1024 bytes
      # 1 MB = 1024 KB
      # 1 GB = 1024 MB
      def deal(str)
        str  = str.upcase.gsub(/\s+/, "")
        str.scan(/(\d+)(#{UNIT_SEQ.join("|")})/)[0]
      end
      def to(str, to_unit, decimal=1)
        _to(str, to_unit, decimal) rescue str
      end
      def _to(str, to_unit, decimal=1)
        to_unit = to_unit.upcase
        num, unit = BKMG::Base.deal(str)
        diff = UNIT_SEQ.index(to_unit) - UNIT_SEQ.index(unit)
        if diff > 0
          (num.to_f/1024**diff).round(decimal).to_s + to_unit
        else
          [num, unit].join 
        end
      end
      def best(str, decimal=1)
        _best(str, decimal) rescue str
      end
      def _best(str, decimal=1)
        num, unit = BKMG::Base.deal(str)
        index = UNIT_SEQ.index(unit)
        while index <= UNIT_SEQ.length - 1 and num.to_f/1024 > 1
          num = num.to_f/1024
          index += 1
        end
        [num.to_f.round(decimal), UNIT_SEQ[index]].join
      end
    end
  end
end

#["2124", "asdfa k", "123 b", "123 kb", "123 k","2423 mb", "1424 g"].each_with_index do |str, index|
#  puts "%s - %s" % [str, BKMG::Base.to(str, "g", index+1).to_s]
#  puts "%s - %s" % [str, BKMG::Base.best(str, 0)]
#end
