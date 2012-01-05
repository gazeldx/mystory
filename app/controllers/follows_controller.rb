class FollowsController < ApplicationController

  def follow_me
    if session[:id].nil?
      flash[:notice] = 'Please login!'
      redirect_to SITE_URL
    else
      follower = User.find(session[:id])
      follower.follow(@user)
      redirect_to :back
    end
  end

  def unfollow_me
    if session[:id].nil?
      flash[:notice] = 'Please login!'
      redirect_to SITE_URL
    else
      follower = User.find(session[:id])
      follower.stop_following(@user)
      redirect_to :back
    end
  end
end
