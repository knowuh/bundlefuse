class AddEndToNode < ActiveRecord::Migration
  def self.up
    add_column :nodes, :end, :timestamp
  end

  def self.down
    remove_column :nodes, :end
  end
end
