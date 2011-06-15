class FullTextSearch1308039771 < ActiveRecord::Migration
  def self.up
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS towns_fts_idx
    eosql
    execute(<<-'eosql'.strip)
      CREATE index towns_fts_idx
      ON towns
      USING gin((to_tsvector('english', coalesce("towns"."name", '') || ' ' || coalesce("towns"."region_name", ''))))
    eosql
  end

  def self.down
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS towns_fts_idx
    eosql
  end
end
