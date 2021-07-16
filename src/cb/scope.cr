require "./action"

require "./scope_checks/check"

class CB::Scope < CB::Action
  property cluster_id : String?

  def call
    p ::Scope::Check.all.first.type.new.go
  end
end
