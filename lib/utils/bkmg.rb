#encoding: utf-8
#   Computer storage measuremen conversion.
#
#     1 B = 1 byte = 8 bit 
#     1 KB = 1024 bytes    , kilo
#     1 MB = 1024 KB       , mega 
#     1 GB = 1024 MB       , giga
#     1 TB = 1024 GB       , tera
#     1 PB = 1024 TB       , peta
#     1 EB = 1024 PB       , exa
#     1 ZB = 1024 EB       , zetta
#     1 YB = 1024 ZB       , yotta
#
#   author: jay(jay_li@solife.us) 
#   date: 2015/04/07
#
#   usage:
#
#   BKMG::Base.to("123 b", "G", -1) => 1.1455267667770386e-07G
#   BKMG::Base.to("123 b", "k", 0) => 0K
#   BKMG::Base.best("123 b") => 123B
#   BKMG::Base.to("123 kb", "G", -1) => 0.00011730194091796875G
#   BKMG::Base.to("123 kb", "k", 0) => 123K 
#   BKMG::Base.best("123 kb") => 123K
#   BKMG::Base.to("2423 mb", "G", -1) => 2.3662109375G
#   BKMG::Base.to("2423 mb", "k", 0) => 2481152K 
#   BKMG::Base.best("2423 mb") => 2G
#   BKMG::Base.to("1424 g", "G", -1) => 1424G
#   BKMG::Base.to("1424 g", "k", 0) => 1493172224K
#   BKMG::Base.best("1424 g") => 1424G
#
module BKMG
  class Base 
    class << self
      UNIT_SEQ = %w(B K M G T P)

      # unit turn up or down to target unit
      # params:
      #   str: size string and unit
      #   to_unit: target unit
      #   ndigits: precision in decimal digits (default 0 digits)
      #            don't truncate when ndigits lower than zero
      def to(str, to_unit, ndigits=0)
        _to(str, to_unit, ndigits) rescue str
      end

      # unit turn up and numberic great zero
      # params:
      #   str: size string and unit 
      #   ndigits: keep dot position
      #            don't truncate when ndigits lower than zero
      def best(str, ndigits=1)
        _best(str, ndigits) rescue str
      end

      # assist methods
      def _deal(str)
        str.upcase.gsub(/\s+/, "").scan(/(\d+)(#{UNIT_SEQ.join("|")})/)[0]
      end

      def _to(str, to_unit, ndigits=1)
        to_unit.upcase!
        num, unit = _deal(str)
        diff = UNIT_SEQ.index(to_unit) - UNIT_SEQ.index(unit)
        unless diff.zero?
          num  = num.to_f.send(diff > 0 ? :/ : :*, 1024**diff.abs)
          num  = num.round(ndigits) if ndigits >= 0
          unit = to_unit 
        end
        [num, unit].join 
      end

      def _best(str, ndigits=1)
        num, unit = _deal(str)
        index = UNIT_SEQ.index(unit)
        while index < UNIT_SEQ.length - 1 and num.to_f/1024 > 1
          num = num.to_f/1024
          index += 1
        end
        num = num.to_f.round(ndigits) if ndigits >= 0
        [num, UNIT_SEQ[index]].join
      end
    end
  end
end
