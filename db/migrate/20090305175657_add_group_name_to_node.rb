class AddGroupNameToNode < ActiveRecord::Migration
  def self.up
    add_column :nodes, :group_name, :string
  end

  def self.down
    remove_column :nodes, :group_name
  end
end
