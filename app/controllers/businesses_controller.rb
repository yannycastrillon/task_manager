class BusinessesController < ApplicationController
  before_action :set_business, only: %i[ show edit update destroy ]

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
      @business = Business.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def business_params
      params.require(:business).permit(:name, :address, :phone, :email, :notes, :status)
    end
end
