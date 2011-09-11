class WagersController < ApplicationController
  before_filter :require_user 
  before_filter :load_bet
  
  def index
    @wagers = @bet.wagers
  end

  def show
    @wager = Wager.find(params[:id])
  end

  def new
    @wager = @bet.wagers.build
  end

  def create
    @wager = Wager.new(params[:wager])
    @wager.user = current_user
    @wager.bet = @bet

    if @wager.save
      redirect_to bet_wagers_path(@bet.id, @wager.id), notice: 'Wager was successfully created.'
    else
      render action: "new"
    end
  end
  
  private 
    def load_bet
      @bet = Bet.find(params[:bet_id])
    end
end
