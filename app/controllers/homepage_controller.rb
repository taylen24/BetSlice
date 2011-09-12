class HomepageController < ApplicationController
  before_filter :require_user, :only => [:dashboard]
  
  def index
    redirect_to dashboard_url if current_user.present?
  end

  def dashboard
  end

end
