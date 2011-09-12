class AddWinPerCreditToBet < ActiveRecord::Migration
  def self.up
    add_column :bets, :win_per_credit, :integer
  end

  def self.down
    remove_column :bets, :win_per_credit
  end
end
