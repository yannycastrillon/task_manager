class CleaningAssignmentsController < ApplicationController
  before_action :set_cleaning_assignment, only: %i[ show edit update destroy ]

  # GET /cleaning_assignments or /cleaning_assignments.json
  def index
    @cleaning_assignments = CleaningAssignment.includes(:business, :team)
                                              .order(scheduled_date: :asc)
  end

  # GET /cleaning_assignments/1 or /cleaning_assignments/1.json
  def show
    @business_tasks = @cleaning_assignment.business.tasks.includes(:team, :assigned_to)
    @team_tasks = @cleaning_assignment.team.tasks.includes(:business, :assigned_to)
  end

  # GET /cleaning_assignments/new
  def new
    @cleaning_assignment = CleaningAssignment.new
  end

  # GET /cleaning_assignments/1/edit
  def edit
    @business_tasks = @cleaning_assignment.business.tasks.includes(:team, :assigned_to)
    @team_tasks = @cleaning_assignment.team.tasks.includes(:business, :assigned_to)
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
      @cleaning_assignment = CleaningAssignment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cleaning_assignment_params
      params.require(:cleaning_assignment).permit(
        :business_id,
        :team_id,
        :scheduled_date,
        :started_at,
        :completed_at,
        :estimated_duration_minutes,
        :actual_duration_minutes,
        :notes,
        :special_instructions,
        :number_of_windows,
        :number_of_floors,
        :requires_special_equipment,
        :requires_insurance_verification,
        :status,
        :price,
        :payment_status,
        :last_cleaned_at,
        :cleaning_frequency_days,
        :is_recurring,
        :recurrence_pattern,
        :recurrence_end_date
      )
    end
end
