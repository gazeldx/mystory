class FollowsController < ApplicationController
  layout 'memoir'
  
  def follow_me
    if session[:id].nil?
      flash[:notice] = t'please_login'
      redirect_to site_url
    else
      follower = User.find(session[:id])
      follower.follow(@user)
      if @m
        flash[:notice] = t'follow_succ'
        render 'm/shared/notice', layout: 'm/portal'
      else
        redirect_to :back
      end
    end
  end

  def unfollow_me
    if session[:id].nil?
      flash[:notice] = t'please_login'
      redirect_to site_url
    else
      follower = User.find(session[:id])
      follower.stop_following(@user)
      if @m
        flash[:notice] = t'unfollow_succ'
        render 'm/shared/notice', layout: 'm/portal'
      else
        redirect_to :back
      end
    end
  end

  def followers
    render mr, layout: 'm/portal' if @m
  end

  def following
    render mr, layout: 'm/portal' if @m
  end

  
end
