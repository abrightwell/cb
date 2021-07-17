require "./check"

module Scope
  @[Meta(name: "Cache Hit Rate", flag: "cache-hit", desc: "Show index and table cache hit rate")]
  class CacheHit < Check
    def query
      <<-SQL
        SELECT
          'index hit rate' AS name,
          (sum(idx_blks_hit)) / nullif(sum(idx_blks_hit + idx_blks_read),0)::float AS ratio
        FROM pg_statio_user_indexes
        UNION ALL
        SELECT
         'table hit rate' AS name,
          sum(heap_blks_hit) / nullif(sum(heap_blks_hit) + sum(heap_blks_read),0)::float AS ratio
        FROM pg_statio_user_tables;
      SQL
    end
  end
end
