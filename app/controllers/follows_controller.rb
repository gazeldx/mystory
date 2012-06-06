class FollowsController < ApplicationController
  layout 'memoir'
  
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

  def followers
    render mr, layout: 'm/portal' if @m
  end

  def following
    render mr, layout: 'm/portal' if @m
  end

  
end
