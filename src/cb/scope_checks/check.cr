require "db"
require "pg"

module Scope
  annotation Meta
  end

  abstract class Check
    record Metadata, type : Check.class, name : String, desc : String, flag : String? = nil do
      def flag
        f = @flag || @name.downcase
        "--#{f}"
      end
    end

    def self.all
      {{
        Check.subclasses.map do |s|
          ann = s.annotation(Meta)
          raise "#{s} is missing Meta annotation" unless ann
          "Metadata.new(#{s}, #{ann.args.empty? ? "".id : "#{ann.args.splat},".id}#{ann.named_args.double_splat})".id
        end.sort(&.flag)
      }}
    end

    property conn : DB::Database

    def initialize(@conn)
    end

    abstract def query

    def run
      simple_run
    end

    def simple_run
      headers = Array(String).new
      result = Array(Array(String)).new
      conn.query(query) do |rs|
        headers = rs.column_names
        rs.each do
          row = Array(String).new
          rs.column_count.times { |i| row << rs.read.to_s }
          result << row
        end
      end
      t = Table.new(headers, result)

      puts t unless result.empty?
    end
  end

  struct Table
    property headers = [] of String
    property rows = [] of Array(String)
    property widths = [] of Int32

    def initialize(@headers, @rows)
      ws = [] of Int32
      (0...headers.size).each do |i|
        ws << ((rows.map(&.[i].size) + [headers[i].size]).max? || 0)
      end
      @widths = ws
    end

    def to_s(io : IO)
      headers.map_with_index { |h, i| h.center(widths[i]).colorize.t_name }.join(io, " │ ")
      io << "\n"
      headers.map_with_index { |h, i| "─"*widths[i] }.join(io, "─┼─")
      io << "\n"
      rows.each do |cols|
        cols.map_with_index do |c, i|
          first = c[0]?
          if first.try &.ascii_number?
            c.rjust(widths[i])
          else
            c.ljust(widths[i])
          end
        end.join(io, " │ ")
        io << "\n"
      end
    end
  end
end
