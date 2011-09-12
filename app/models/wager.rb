class Wager < ActiveRecord::Base

  belongs_to :user
  belongs_to :bet
  belongs_to :bet_option
  
  validates_presence_of :user_id, :amount, :bet_id, :bet_option_id
  validate :check_user_has_credits
  
  validates :amount, :numericality => {:greater_than => 0}
    
  before_create :check_bet_active
  after_create :deduct_user_points
  
  def active?
    bet.active?
  end
  
  def win?
    !bet.active? && bet.winning_option == bet_option
  end
  
  private
  
    def check_user_has_credits
      errors.add(:amount, 'You don\'t have enough credits remaining') if user.points < amount
    end

    def check_bet_active
      errors.add(:bet, 'This bet is no longer active') unless bet.active?
    end
    
    def deduct_user_points
      user.points = user.points - amount
      user.save!
    end

end
