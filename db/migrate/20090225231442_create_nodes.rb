class CreateNodes < ActiveRecord::Migration
  def self.up
    create_table :nodes do |t|
      t.integer :bundle_id
      t.integer :parent_id
      t.timestamps
    end
  end

  def self.down
    drop_table :nodes
  end
end
