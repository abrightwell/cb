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
      result = Array(Array(String)).new
      conn.query(query) do |rs|
        rs.each do
          row = Array(String).new
          rs.column_count.times { |i| row << rs.read.to_s }
          result << row
        end
      end
      pp result
    end
  end
end
