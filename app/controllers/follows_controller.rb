class FollowsController < ApplicationController
  before_filter :super_admin, :only => :update_follow_count
  layout 'memoir'
  
  def follow_me
    if session[:id].nil?
      flash[:notice] = t'please_login'
      redirect_to site_url
    else
      follower = User.find(session[:id])
      follower.follow(@user)
      follower.update_attribute('following_num', follower.follow_count)
      @user.update_attribute('followers_num', @user.followers_count)
      expire_cache
      if @m
        flash[:notice] = t'follow_succ'
        render 'm/shared/notice', :layout => 'm/portal'
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
      follower.update_attribute('following_num', follower.follow_count)
      @user.update_attribute('followers_num', @user.followers_count)
      expire_cache
      if @m
        flash[:notice] = t'unfollow_succ'
        render 'm/shared/notice', :layout => 'm/portal'
      else
        redirect_to :back
      end
    end
  end

  def followers
    render mr, :layout => 'm/portal' if @m
  end

  def following
    render mr, :layout => 'm/portal' if @m
  end

  def update_follow_count
    users = User.all
    users.each do |user|
      user.update_attribute('following_num', user.follow_count)
      user.update_attribute('followers_num', user.followers_count)
      user.update_attribute('blogs_count', user.blogs.count)
      user.update_attribute('notes_count', user.notes.count)
    end
  end

  private
  def expire_cache
    expire_fragment("side_user_following_#{session[:id]}")
  end
  
end
