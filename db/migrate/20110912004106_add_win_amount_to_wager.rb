class AddWinAmountToWager < ActiveRecord::Migration
  def self.up
    add_column :wagers, :win_amount, :integer
    add_column :wagers, :refund, :integer
  end

  def self.down
    remove_column :wagers, :win_amount
    remove_column :wagers, :refund
  end
end
