class Bet < ActiveRecord::Base
  belongs_to :user

  has_many :bet_options, :autosave => true, :dependent => :destroy
  has_many :wagers
  belongs_to :winning_option, :class_name => "BetOption"

  validates_presence_of :title, :expires_at, :user_id
  
  accepts_nested_attributes_for :bet_options, :allow_destroy => true, :reject_if => :all_blank

  scope :active, where('expires_at > ?', DateTime.now)

  def active?
    self.expires_at > DateTime.now
  end
  
  def report_result!(option_id, current_user)
    return false unless user == current_user || winning_option_id.blank?
    self.winning_option_id = option_id
    self.expires_at = DateTime.now if active?
    result = self.save!
    
    total_loss_credits = 0
    total_win_credits = 0
    
    self.wagers.each do |wager|
      if wager.win?
        total_win_credits += wager.amount
      else
        total_loss_credits += wager.amount
      end
    end
    if total_win_credits > 0
      self.wagers.each do |wager|
        if wager.win?
          wager.user.points += ((total_loss_credits.to_f / total_win_credits.to_f) * wager.amount.to_f).floor
          wager.user.save!
        end
      end
    end
  end
end
