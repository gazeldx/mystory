class IdolsController < ApplicationController
  layout 'help'
  before_filter :url_authorize, :except=> [:show]
  
  def index
    @idols = @user.idols
    @idol = Idol.new
  end

  def create
    f_idol = Idol.find_by_name(params[:idol][:name])
    f_idol = Idol.create(params[:idol]) if f_idol.nil?
    ri = f_idol.ridols.build
    ri.user_id = session[:id]
    ri.save
    flash[:notice] = t('new_succ')
    expire_cache
    redirect_to idols_path
  end

  def destroy
    if Ridol.where("idol_id = ?", params[:id]).size > 1
      Ridol.delete_all ["user_id = ? AND idol_id = ?", session[:id], params[:id]]
    else
      @idol = Idol.find(params[:id])
      @idol.destroy
    end
    expire_cache
    redirect_to idols_path, :notice => t('delete_succ')
  end

  def show
    @idol = Idol.find_by_name(params[:name])
    @users = @idol.users
    @tags = Tag.where(["name = ?", params[:name]]).includes(:blog => [:user, :tags]).limit(100)
    @notetags = Notetag.where(["name = ?", params[:name]]).includes(:note => [:user, :notetags]).limit(100)
    unless @user.nil?
      tags = @user.tags.where(["name = ?", params[:name]]).includes(:blog => [:user, :tags]).limit(100)
      notetags = @user.notetags.where(["name = ?", params[:name]]).includes(:note => [:user, :notetags]).limit(100)
      @tags = (tags + @tags).uniq
      @notetags = (notetags + @notetags).uniq
    end
    render :layout => 'help'
  end

  private
  def expire_cache
    expire_fragment("side_idols_#{session[:id]}")
  end

  # GET /idols/1
  # GET /idols/1.json
#  def show
#    @idol = Idol.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.json { render json: @idol }
#    end
#  end

  # GET /idols/new
  # GET /idols/new.json
#  def new
#    @idol = Idol.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.json { render json: @idol }
#    end
#  end

  # GET /idols/1/edit
#  def edit
#    @idol = Idol.find(params[:id])
#  end

 

  # PUT /idols/1
  # PUT /idols/1.json
#  def update
#    @idol = Idol.find(params[:id])
#
#    respond_to do |format|
#      if @idol.update_attributes(params[:idol])
#        format.html { redirect_to @idol, :notice => 'Idol was successfully updated.' }
#        format.json { head :ok }
#      else
#        format.html { render action: "edit" }
#        format.json { render json: @idol.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /idols/1
  # DELETE /idols/1.json
  
end
