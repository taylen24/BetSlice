class CreateWagers < ActiveRecord::Migration
  def self.up
    create_table :wagers do |t|
      t.references :bet
      t.references :user
      t.references :bet_option
      t.integer :amount
      t.timestamps
    end
  end
  
  def self.down
    drop_table :wagers
  end
end
