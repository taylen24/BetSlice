class BetOption < ActiveRecord::Base
  belongs_to :bet
  has_many :wagers
  
  def win?
    !bet.active? && bet.winning_option == self
  end
end
