class CleaningAssignmentsController < ApplicationController
  before_action :set_cleaning_assignment, only: %i[ show edit update destroy ]

  # GET /cleaning_assignments or /cleaning_assignments.json
  def index
    @cleaning_assignments = CleaningAssignment.includes(:business, :team)
                                              .order(scheduled_date: :asc)
  end

  # GET /cleaning_assignments/1 or /cleaning_assignments/1.json
  def show
    @tasks = @cleaning_assignment.tasks
  end

  # GET /cleaning_assignments/new
  def new
    @cleaning_assignment = CleaningAssignment.new
  end

  # GET /cleaning_assignments/1/edit
  def edit
    @tasks = @cleaning_assignment.tasks
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
        format.json { render json: { success: true, status: @cleaning_assignment.status }, status: :ok }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cleaning_assignment.errors, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("form_errors", partial: "shared/errors", locals: { errors: @cleaning_assignment.errors }) }
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
      @cleaning_assignment = CleaningAssignment.includes(:business, :team, :assigned_to, :tasks).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cleaning_assignment_params
      params.require(:cleaning_assignment).permit(
        :notes,
        :started_at,
        :completed_at,
        :scheduled_date,
        :total_estimated_duration_minutes,
        :actual_duration_minutes,
        :status,
        :priority,
        :team_id,
        :business_id,
        :assigned_to_id,
        :recurring_assignment_id,
        task_ids: []
      )
    end
end
