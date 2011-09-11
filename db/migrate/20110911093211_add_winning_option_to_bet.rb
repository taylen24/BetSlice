class AddWinningOptionToBet < ActiveRecord::Migration
  def self.up
    add_column :bets, :winning_option_id, :integer
  end

  def self.down
    remove_column :bets, :winning_option_id
  end
end
