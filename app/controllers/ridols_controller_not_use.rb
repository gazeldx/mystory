class RidolsController < ApplicationController
  # GET /ridols
  # GET /ridols.json
  def index
    @ridols = Ridol.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ridols }
    end
  end

  # GET /ridols/1
  # GET /ridols/1.json
  def show
    @ridol = Ridol.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ridol }
    end
  end

  # GET /ridols/new
  # GET /ridols/new.json
  def new
    @ridol = Ridol.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ridol }
    end
  end

  # GET /ridols/1/edit
  def edit
    @ridol = Ridol.find(params[:id])
  end

  # POST /ridols
  # POST /ridols.json
  def create
    @ridol = Ridol.new(params[:ridol])

    respond_to do |format|
      if @ridol.save
        format.html { redirect_to @ridol, :notice => 'Ridol was successfully created.' }
        format.json { render json: @ridol, :status => :created, location: @ridol }
      else
        format.html { render action: "new" }
        format.json { render json: @ridol.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ridols/1
  # PUT /ridols/1.json
  def update
    @ridol = Ridol.find(params[:id])

    respond_to do |format|
      if @ridol.update_attributes(params[:ridol])
        format.html { redirect_to @ridol, :notice => 'Ridol was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @ridol.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ridols/1
  # DELETE /ridols/1.json
  def destroy
    @ridol = Ridol.find(params[:id])
    @ridol.destroy

    respond_to do |format|
      format.html { redirect_to ridols_url }
      format.json { head :ok }
    end
  end
end
