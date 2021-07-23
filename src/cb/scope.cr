require "./action"
require "./scope_checks/*"

class CB::Scope < CB::Action
  property cluster_id : String?
  property checks : Array(::Scope::Check.class) = [] of ::Scope::Check.class

  def call
    #    uri = client.get_cluster_default_role(cluster_id).uri
    uri = "postgres:///"
    DB.open(uri) do |db|
      ::Scope::Check.all.map(&.type.new(db)).each do |c|
        @output << c << "\n"
      end
    end
  end
end
