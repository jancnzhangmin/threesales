class SystemlogsController < ApplicationController
  before_action :set_systemlog, only: [:show, :edit, :update, :destroy]

  # GET /systemlogs
  # GET /systemlogs.json
  def index
    @systemlogs = Systemlog.all
  end

  # GET /systemlogs/1
  # GET /systemlogs/1.json
  def show
  end

  # GET /systemlogs/new
  def new
    @systemlog = Systemlog.new
  end

  # GET /systemlogs/1/edit
  def edit
  end

  # POST /systemlogs
  # POST /systemlogs.json
  def create
    @systemlog = Systemlog.new(systemlog_params)

    respond_to do |format|
      if @systemlog.save
        format.html { redirect_to @systemlog, notice: 'Systemlog was successfully created.' }
        format.json { render :show, status: :created, location: @systemlog }
      else
        format.html { render :new }
        format.json { render json: @systemlog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /systemlogs/1
  # PATCH/PUT /systemlogs/1.json
  def update
    respond_to do |format|
      if @systemlog.update(systemlog_params)
        format.html { redirect_to @systemlog, notice: 'Systemlog was successfully updated.' }
        format.json { render :show, status: :ok, location: @systemlog }
      else
        format.html { render :edit }
        format.json { render json: @systemlog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /systemlogs/1
  # DELETE /systemlogs/1.json
  def destroy
    @systemlog.destroy
    respond_to do |format|
      format.html { redirect_to systemlogs_url, notice: 'Systemlog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_systemlog
      @systemlog = Systemlog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def systemlog_params
      params.require(:systemlog).permit(:table, :userid, :userip, :textout)
    end
end
