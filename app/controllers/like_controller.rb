class LikeController < ApplicationController
  layout 'like'

  def index
    following = Follow.where(["follower_id = ?", @user.id])
    following_ids = following.collect{|f| f.followable_id}
    following_ids << session[:id]
    @note = Note.new
    t = params[:t]
#    memoir updated show here .
    if t.nil?
      @notes = Note.where(:user_id => following_ids).order('created_at DESC').limit(100)
      @blogs = Blog.where(:user_id => following_ids).order('created_at DESC').limit(25)
      @all = (@notes | @blogs).sort_by{|x| x.created_at}.reverse!
    elsif t == 'note'
      @all = Note.where(:user_id => following_ids).order('created_at DESC').limit(100)
    elsif t == 'blog'
      @all = Blog.where(:user_id => following_ids).order('created_at DESC').limit(100)
    end     
  end
end
