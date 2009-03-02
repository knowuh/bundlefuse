class AddStartToNode < ActiveRecord::Migration
  def self.up
    add_column :nodes, :start, :timestamp
  end

  def self.down
    remove_column :nodes, :start
  end
end
