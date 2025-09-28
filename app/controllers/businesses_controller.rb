class BusinessesController < ApplicationController
  before_action :set_business, only: %i[ show edit update destroy ]
  authorize_resource

  # GET /businesses or /businesses.json
  def index
    businesses = Business.all

    if params[:search].present?
      businesses = businesses.where("name ILIKE ? OR email ILIKE ? OR phone ILIKE ? OR address ILIKE ?",
        "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    end

    if params[:status].present?
      businesses = businesses.where(status: params[:status])
    end

    businesses = businesses.group_by(&:status)
    @active_businesses = businesses.fetch("active", [])
    @inactive_businesses = businesses.fetch("inactive", [])

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /businesses/1 or /businesses/1.json
  def show
    assignments = @business.cleaning_assignments
    assignments_by_status = @business.cleaning_assignments.group_by(&:status)

    @total_assignments = assignments.count
    @active_assignments = assignments_by_status.fetch("active", [])
    @completed_assignments = assignments_by_status.fetch("completed", [])
    @scheduled_assignments = assignments_by_status.fetch("scheduled", [])
    @in_progress_assignments = assignments_by_status.fetch("in_progress", [])
  end

  # GET /businesses/new
  def new
    @business = Business.new
  end

  # GET /businesses/1/edit
  def edit
  end

  # POST /businesses or /businesses.json
  def create
    @business = Business.new(business_params)

    if @business.save
      redirect_to @business, notice: "Business was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /businesses/1 or /businesses/1.json
  def update
    if @business.update(business_params)
      redirect_to @business, notice: "Business was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @business.destroy
    redirect_to businesses_url, notice: "Business was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business
      @business = Business.includes(:cleaning_assignments).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def business_params
      params.require(:business).permit(:name, :address, :phone, :email, :notes, :status)
    end
end
