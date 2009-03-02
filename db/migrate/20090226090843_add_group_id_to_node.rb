class AddGroupIdToNode < ActiveRecord::Migration
  def self.up
    add_column :nodes, :group_id, :integer
  end

  def self.down
    remove_column :nodes, :group_id
  end
end
