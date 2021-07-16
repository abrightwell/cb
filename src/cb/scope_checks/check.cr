module Scope
  annotation Meta
  end

  abstract class Check
    def self.all
      {{
        Check.subclasses.map do |s|
          raise s.stringify + " is missing Meta annotation" unless s.annotation(Meta)
          raise s.stringify + " is missing Meta :name annotation" unless s.annotation(Meta).named_args[:name]
          raise s.stringify + " Meta :name annotation is not a string" unless s.annotation(Meta).named_args[:name].is_a? StringLiteral
          raise s.stringify + " is missing Meta :desc' annotationg" unless s.annotation(Meta).named_args[:desc]
          raise s.stringify + " Meta :desc annotation is not a string" unless s.annotation(Meta).named_args[:desc].is_a? StringLiteral
          {type: s, name: s.annotation(Meta).named_args[:name], desc: s.annotation(Meta).named_args[:desc]}
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

  @[Meta(name: "three", desc: "A second check")]
  class Third < Check
    def go
      "sure"
    end
  end
end
