class CreateBets < ActiveRecord::Migration
  def self.up
    create_table :bets do |t|
      t.references :user
      t.string :title
      t.string :description
      t.datetime :expires_at
      t.timestamps
    end
  end
  
  def self.down
    drop_table :bets
  end
    
end
