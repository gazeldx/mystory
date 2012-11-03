class TagsController < ApplicationController
  layout 'memoir'
  include Tags
  
  def index
    if @user.nil?
      
    else
      tags_index
    end
  end
  
  def show
    if @user.nil?
      #      @tags = Tag.where(["name = ?", params[:name]]).includes(:blog => [:user, :tags]).limit(100)
      #      @notetags = Notetag.where(["name = ?", params[:name]]).includes(:note => [:user, :notetags]).limit(100)
      #      render 'show_portal', :layout => 'help'
    else
      tags_index
      @blogtags = @user.tags.where(["name = ?", params[:name]]).includes(:blog => [:user, :tags]).limit(100).order('blog_id DESC')
      @notetags = @user.notetags.where(["name = ?", params[:name]]).includes(:note => [:user, :notetags]).limit(100).order('note_id DESC')
    end
  end

end