class EnjoysController < ApplicationController
  # GET /enjoys
  # GET /enjoys.json
  def index
    @enjoys = Enjoy.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @enjoys }
    end
  end

  # GET /enjoys/1
  # GET /enjoys/1.json
  def show
    @enjoy = Enjoy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @enjoy }
    end
  end

  # GET /enjoys/new
  # GET /enjoys/new.json
  def new
    @enjoy = Enjoy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @enjoy }
    end
  end

  # GET /enjoys/1/edit
  def edit
    @enjoy = Enjoy.find(params[:id])
  end

  # POST /enjoys
  # POST /enjoys.json
  def create
    @enjoy = Enjoy.new(params[:enjoy])

    respond_to do |format|
      if @enjoy.save
        format.html { redirect_to @enjoy, :notice => 'Enjoy was successfully created.' }
        format.json { render json: @enjoy, :status => :created, location: @enjoy }
      else
        format.html { render action: "new" }
        format.json { render json: @enjoy.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /enjoys/1
  # PUT /enjoys/1.json
  def update
    @enjoy = Enjoy.find(params[:id])

    respond_to do |format|
      if @enjoy.update_attributes(params[:enjoy])
        format.html { redirect_to @enjoy, :notice => 'Enjoy was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @enjoy.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /enjoys/1
  # DELETE /enjoys/1.json
  def destroy
    @enjoy = Enjoy.find(params[:id])
    @enjoy.destroy

    respond_to do |format|
      format.html { redirect_to enjoys_url }
      format.json { head :ok }
    end
  end
end
