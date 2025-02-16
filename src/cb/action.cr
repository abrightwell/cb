module CB
  abstract class Action
    Error = Program::Error

    property output : IO
    getter client

    def initialize(@client : Client, @output = STDOUT)
    end

    abstract def call

    private def raise_arg_error(field, value)
      raise Error.new "Invalid #{field.colorize.bold}: '#{value.to_s.colorize.red}'"
    end

    private def check_required_args
      missing = [] of String
      yield missing
      unless missing.empty?
        s = missing.size > 1 ? "s" : ""
        raise Error.new "Missing required argument#{s}: #{missing.map(&.colorize.red).join(", ")}"
      end
      true
    end
  end
end
