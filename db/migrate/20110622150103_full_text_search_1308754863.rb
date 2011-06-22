class FullTextSearch1308754863 < ActiveRecord::Migration
  def self.up
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS counties_fts_idx
    eosql
    execute(<<-'eosql'.strip)
      CREATE index counties_fts_idx
      ON counties
      USING gin((to_tsvector('english', coalesce("counties"."name", ''))))
    eosql
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS towns_fts_idx
    eosql
    execute(<<-'eosql'.strip)
      CREATE index towns_fts_idx
      ON towns
      USING gin((to_tsvector('english', coalesce("towns"."name", '') || ' ' || coalesce("towns"."county", ''))))
    eosql
  end

  def self.down
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS counties_fts_idx
    eosql
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS towns_fts_idx
    eosql
  end
end
