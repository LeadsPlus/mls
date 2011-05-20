class FullTextSearch1305915837 < ActiveRecord::Migration
  def self.up
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS houses_fts_idx
    eosql
    execute(<<-'eosql'.strip)
      CREATE index houses_fts_idx
      ON houses
      USING gin((to_tsvector('english', coalesce("houses"."county", ''))))
    eosql
  end

  def self.down
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS houses_fts_idx
    eosql
  end
end
