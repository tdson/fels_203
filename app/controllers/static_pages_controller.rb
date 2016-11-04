class StaticPagesController < ApplicationController
  def index
    if logged_in?
      @activities = Activity.user_activities(current_user).newest
        .paginate page: params[:page], per_page: Settings.activities_per_page
      @word = Word.only_correct_meaning.random.take(Settings.daily_word).first
      load_data current_user
    end
  end
end
