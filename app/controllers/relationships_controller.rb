class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by_id params[:followed_id]
    return redirect_if_not_found unless @user
    current_user.follow @user
    @active_relationship = current_user.active_relationships
      .find_by followed_id: @user.id
    return redirect_if_not_found url: @user unless @user
    @followers_size = @user.followers.size
    respond
  end

  def destroy
    relationship = Relationship.find_by_id(params[:id])
    return redirect_if_not_found unless relationship
    @user = relationship.followed
    return redirect_if_not_found url: @user unless current_user.following? @user
    current_user.unfollow @user
    @active_relationship = current_user.active_relationships.build
    @followers_size = @user.followers.size
    respond
  end

  private
  def redirect_if_not_found options = {url: current_user}
    destination_url = options[:url]
    flash[:danger] = t "relationships.fails"
    redirect_to destination_url and return
  end

  def respond
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
end
