class TagsController < ApplicationController
  layout 'memoir'
  
  def index
    if @user.nil?
      @tags = Tag.where(["name = ?", params[:name]]).includes(:blog => [:user, :tags]).limit(100)
      @notetags = Notetag.where(["name = ?", params[:name]]).includes(:note => [:user, :notetags]).limit(100)
      render 'index_portal', layout: 'help'
    else
      @tags = @user.tags.where(["name = ?", params[:name]]).includes(:blog => [:user, :tags]).limit(100)
      @notetags = @user.notetags.where(["name = ?", params[:name]]).includes(:note => [:user, :notetags]).limit(100)
    end
  end

end