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
    return false unless user == current_user && winning_option_id.blank? && option_id.present?
    self.winning_option_id = option_id
    self.expires_at = DateTime.now if active?
    self.save!
    
    #Calculate all totals
    totals = {}
    self.wagers.each do |wager|
      totals[wager.bet_option.id] ||= 0
      totals[wager.bet_option.id] += wager.amount
    end
    
    #Calculate winning total
    winning_total = totals[winning_option_id] || 0
    
    #Refund wager totals down to winning total in input ratio
    self.wagers.each do |wager|
      if wager.win?
        wager.refund = wager.amount
      else
        if totals[winning_option_id] < totals[wager.bet_option.id]
          wager.refund = ((wager.amount.to_f / totals[wager.bet_option.id].to_f) * (totals[wager.bet_option.id].to_f - totals[winning_option_id].to_f)).floor
        else
          wager.refund = 0
        end
      end
      wager.save!
      wager.user.points += wager.refund
      wager.user.save!
    end
    
    #Drop totals down to accomodate refunds (we do this in a second step so we can use floor in the previous each statement)
    #also calc win/loss totals
    total_win = 0
    total_loss = 0
    totals.each do |key, value|
      totals[key] = totals[winning_option_id] if value > totals[winning_option_id]
      total_win += totals[key] if key == winning_option_id
      total_loss += totals[key] unless key == winning_option_id
    end

    #calc win per credit
    self.win_per_credit = total_loss.to_f / total_win.to_f rescue 0
    result = self.save!

    #update wager win amounts and assign points
    self.wagers.each do |wager|
      if wager.win?
        wager.win_amount = (win_per_credit * wager.amount).floor
        wager.user.points += wager.win_amount
        wager.user.save!
      else
        wager.win_amount = -wager.amount
      end
      wager.save!
    end

  end
end
