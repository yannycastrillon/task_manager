class CleaningAssignmentsController < ApplicationController
  before_action :set_cleaning_assignment, only: %i[ show edit update destroy ]

  # GET /cleaning_assignments or /cleaning_assignments.json
  def index
    @cleaning_assignments = CleaningAssignment.all
  end

  # GET /cleaning_assignments/1 or /cleaning_assignments/1.json
  def show
  end

  # GET /cleaning_assignments/new
  def new
    @cleaning_assignment = CleaningAssignment.new
  end

  # GET /cleaning_assignments/1/edit
  def edit
  end

  # POST /cleaning_assignments or /cleaning_assignments.json
  def create
    @cleaning_assignment = CleaningAssignment.new(cleaning_assignment_params)

    respond_to do |format|
      if @cleaning_assignment.save
        format.html { redirect_to @cleaning_assignment, notice: "Cleaning assignment was successfully created." }
        format.json { render :show, status: :created, location: @cleaning_assignment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cleaning_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cleaning_assignments/1 or /cleaning_assignments/1.json
  def update
    respond_to do |format|
      if @cleaning_assignment.update(cleaning_assignment_params)
        format.html { redirect_to @cleaning_assignment, notice: "Cleaning assignment was successfully updated." }
        format.json { render :show, status: :ok, location: @cleaning_assignment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cleaning_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cleaning_assignments/1 or /cleaning_assignments/1.json
  def destroy
    @cleaning_assignment.destroy!

    respond_to do |format|
      format.html { redirect_to cleaning_assignments_path, status: :see_other, notice: "Cleaning assignment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cleaning_assignment
      @cleaning_assignment = CleaningAssignment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def cleaning_assignment_params
      params.fetch(:cleaning_assignment, {})
    end
end
