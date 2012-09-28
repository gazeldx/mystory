class RhobbiesController < ApplicationController
  # GET /rhobbies
  # GET /rhobbies.json
  def index
    @rhobbies = Rhobby.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rhobbies }
    end
  end

  # GET /rhobbies/1
  # GET /rhobbies/1.json
  def show
    @rhobby = Rhobby.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rhobby }
    end
  end

  # GET /rhobbies/new
  # GET /rhobbies/new.json
  def new
    @rhobby = Rhobby.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rhobby }
    end
  end

  # GET /rhobbies/1/edit
  def edit
    @rhobby = Rhobby.find(params[:id])
  end

  # POST /rhobbies
  # POST /rhobbies.json
  def create
    @rhobby = Rhobby.new(params[:rhobby])

    respond_to do |format|
      if @rhobby.save
        format.html { redirect_to @rhobby, notice: 'Rhobby was successfully created.' }
        format.json { render json: @rhobby, status: :created, location: @rhobby }
      else
        format.html { render action: "new" }
        format.json { render json: @rhobby.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rhobbies/1
  # PUT /rhobbies/1.json
  def update
    @rhobby = Rhobby.find(params[:id])

    respond_to do |format|
      if @rhobby.update_attributes(params[:rhobby])
        format.html { redirect_to @rhobby, notice: 'Rhobby was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @rhobby.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rhobbies/1
  # DELETE /rhobbies/1.json
  def destroy
    @rhobby = Rhobby.find(params[:id])
    @rhobby.destroy

    respond_to do |format|
      format.html { redirect_to rhobbies_url }
      format.json { head :ok }
    end
  end
end
