class CustomizesController < ApplicationController

  def index
    @customize = User.find(session[:id]).customize
    #    @customize = Customize.find(session[:id])
    @customize = Customize.new if @customize.nil?
  end

  def create
    #    customize = User.find(session[:id]).customize
    #    if customize.nil?
    @customize = Customize.new(params[:customize])
    @customize.user_id = session[:id]
    @customize.save
    flash[:notice] = t('photo_upload_succ')
    #    else
    #      customize.update_attributes(params[:customize])
    #      flash[:notice] = t('update_succ')
    #    end
    redirect_to customizes_path
  end

  def update
    customize = User.find(session[:id]).customize
    customize.update_attributes(params[:customize])
    flash[:notice] = t('update_succ')
    redirect_to customizes_path
  end
























  #  # GET /customizes/1
  #  # GET /customizes/1.json
  #  def show
  #    @customize = Customize.find(params[:id])
  #
  #    respond_to do |format|
  #      format.html # show.html.erb
  #      format.json { render json: @customize }
  #    end
  #  end
  #
  #  # GET /customizes/new
  #  # GET /customizes/new.json
  #  def new
  #    @customize = Customize.new
  #
  #    respond_to do |format|
  #      format.html # new.html.erb
  #      format.json { render json: @customize }
  #    end
  #  end
  #
  #  # GET /customizes/1/edit
  #  def edit
  #    @customize = Customize.find(params[:id])
  #  end
  #
  #  # POST /customizes
  #  # POST /customizes.json
  ##  def create
  ##    @customize = Customize.new(params[:customize])
  ##
  ##    respond_to do |format|
  ##      if @customize.save
  ##        format.html { redirect_to @customize, :notice => 'Customize was successfully created.' }
  ##        format.json { render json: @customize, :status => :created, location: @customize }
  ##      else
  ##        format.html { render action: "new" }
  ##        format.json { render json: @customize.errors, :status => :unprocessable_entity }
  ##      end
  ##    end
  ##  end
  #
  #  # PUT /customizes/1
  #  # PUT /customizes/1.json
  #  def update
  #    @customize = Customize.find(params[:id])
  #
  #    respond_to do |format|
  #      if @customize.update_attributes(params[:customize])
  #        format.html { redirect_to @customize, :notice => 'Customize was successfully updated.' }
  #        format.json { head :ok }
  #      else
  #        format.html { render action: "edit" }
  #        format.json { render json: @customize.errors, :status => :unprocessable_entity }
  #      end
  #    end
  #  end
  #
  #  # DELETE /customizes/1
  #  # DELETE /customizes/1.json
  #  def destroy
  #    @customize = Customize.find(params[:id])
  #    @customize.destroy
  #
  #    respond_to do |format|
  #      format.html { redirect_to customizes_url }
  #      format.json { head :ok }
  #    end
  #  end
end
