class TagsController < ApplicationController
  layout 'memoir'

  def index
    if @user.nil?
      
    else
      tags = @user.tags.map {|x| x.name}
      notetags = @user.notetags.map {|x| x.name}
      @tags = (tags + notetags).uniq
    end
  end
  
  def show
    if @user.nil?
#      @tags = Tag.where(["name = ?", params[:name]]).includes(:blog => [:user, :tags]).limit(100)
#      @notetags = Notetag.where(["name = ?", params[:name]]).includes(:note => [:user, :notetags]).limit(100)
#      render 'show_portal', layout: 'help'
    else
      @tags = @user.tags.where(["name = ?", params[:name]]).includes(:blog => [:user, :tags]).limit(100)
      @notetags = @user.notetags.where(["name = ?", params[:name]]).includes(:note => [:user, :notetags]).limit(100)
    end
  end

end