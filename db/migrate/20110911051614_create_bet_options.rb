class CreateBetOptions < ActiveRecord::Migration
  def self.up
    create_table :bet_options do |t|
      t.references :bet
      t.string :label
      t.timestamps
    end
  end
  def self.down
    drop_table :bet_options
  end
end
