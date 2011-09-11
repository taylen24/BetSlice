class AddPointsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :points, :integer, :default => 50, :null => false
  end

  def self.down
    remove_column :users, :points
  end
end
