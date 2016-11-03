class StaticPagesController < ApplicationController
  def index
    if logged_in?
      @activities = Activity.user_activities(current_user).newest
        .paginate page: params[:page], per_page: Settings.activities_per_page
    end
  end
end
