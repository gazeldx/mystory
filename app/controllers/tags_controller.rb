class TagsController < ApplicationController
  layout 'memoir'
  include Tags
  
  def index
    if @user.nil?
      
    else
      tagsIndex
    end
  end
  
  def show
    if @user.nil?
      #      @tags = Tag.where(["name = ?", params[:name]]).includes(:blog => [:user, :tags]).limit(100)
      #      @notetags = Notetag.where(["name = ?", params[:name]]).includes(:note => [:user, :notetags]).limit(100)
      #      render 'show_portal', layout: 'help'
    else
      tagsIndex
      @blogtags = @user.tags.where(["name = ?", params[:name]]).includes(:blog => [:user, :tags]).limit(100)
      @notetags = @user.notetags.where(["name = ?", params[:name]]).includes(:note => [:user, :notetags]).limit(100)
    end
  end

end