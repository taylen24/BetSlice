class ChangeWinPerCreditsType < ActiveRecord::Migration
  def self.up
    change_table :bets do |t|
      t.change :win_per_credit, :float
    end
  end

  def self.down
    change_table :bets do |t|
      t.change :win_per_credit, :integer
    end
  end
end
