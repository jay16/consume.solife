#encoding: utf-8
# usage:
# Record create history cache.
#
module Utils
  module ActionCache
    @@line_limit = 30
    class << self
      def cache_file(base_path = Rails.root)
        file = File.join(base_path, "tmp/action_cache.tmp")
         `test -f #{file} || touch #{file}`
         return file
      end

      def set_line_limit(limit)
        @@line_limit = limit
      end

      def add(arr)
        `echo #{arr.join(",")} >> #{cache_file}`
      end

      def list(rows = @@line_limit)
        IO.readlines(cache_file).last(rows).map do |line|
          line.split(/,/).map(&:strip)
        end
      end
    end
  end
end
