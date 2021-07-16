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
        end
      }}
    end
  end

  @[Meta(name: "First", desc: "A first check")]
  class First < Check
    def go
      "hi"
    end
  end

  @[Meta(name: "Check2", desc: "A second check")]
  class Second < Check
    def go
      "no"
    end
  end

  @[Meta(name: "hi", flag: "greetings", desc: "A second check")]
  class Third < Check
    def go
      "sure"
    end
  end
end
