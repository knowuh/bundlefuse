class AddUuidToNode < ActiveRecord::Migration
  def self.up
    add_column :nodes, :uuid, :text
  end

  def self.down
    remove_column :nodes, :uuid
  end
end
