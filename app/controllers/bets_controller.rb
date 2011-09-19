class BetsController < ApplicationController
  before_filter :require_user 
  def index
    @bets = Bet.active
  end

  def show
    @bet = Bet.find(params[:id])
  end

  def new
    @bet = Bet.new
    5.times { @bet.bet_options.build }
    @bet.expires_at = DateTime.tomorrow
  end

  def edit
    @bet = Bet.find(params[:id])
    unless @bet.user == current_user
      redirect_to @bet, notice: 'You cannot edit that bet, because you didnt create it'
    end
  end

  def create
    @bet = Bet.new(params[:bet])
    @bet.user = current_user
    
    if @bet.save
      redirect_to @bet, notice: 'Bet was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @bet = Bet.find(params[:id])

    if @bet.report_result!(params[:bet][:winning_option], current_user)
      redirect_to @bet, notice: 'Bet result successfully reported.'
    else
      render action: "edit"
    end
  end

  def destroy
    @bet = Bet.find(params[:id])
    @bet.destroy
    redirect_to action: "index", notice: 'Bet was successfully deleted.'
  end
end
