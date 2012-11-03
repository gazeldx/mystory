class RenjoysController < ApplicationController
  # GET /renjoys
  # GET /renjoys.json
  def index
    @renjoys = Renjoy.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @renjoys }
    end
  end

  # GET /renjoys/1
  # GET /renjoys/1.json
  def show
    @renjoy = Renjoy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @renjoy }
    end
  end

  # GET /renjoys/new
  # GET /renjoys/new.json
  def new
    @renjoy = Renjoy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @renjoy }
    end
  end

  # GET /renjoys/1/edit
  def edit
    @renjoy = Renjoy.find(params[:id])
  end

  # POST /renjoys
  # POST /renjoys.json
  def create
    @renjoy = Renjoy.new(params[:renjoy])

    respond_to do |format|
      if @renjoy.save
        format.html { redirect_to @renjoy, :notice => 'Renjoy was successfully created.' }
        format.json { render json: @renjoy, :status => :created, location: @renjoy }
      else
        format.html { render action: "new" }
        format.json { render json: @renjoy.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /renjoys/1
  # PUT /renjoys/1.json
  def update
    @renjoy = Renjoy.find(params[:id])

    respond_to do |format|
      if @renjoy.update_attributes(params[:renjoy])
        format.html { redirect_to @renjoy, :notice => 'Renjoy was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @renjoy.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /renjoys/1
  # DELETE /renjoys/1.json
  def destroy
    @renjoy = Renjoy.find(params[:id])
    @renjoy.destroy

    respond_to do |format|
      format.html { redirect_to renjoys_url }
      format.json { head :ok }
    end
  end
end
