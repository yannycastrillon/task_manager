class TasksController < ApplicationController
  before_action :set_parent
  before_action :set_task, only: %i[ show edit update destroy ]
  allow_unauthenticated_access only: %i[ index edit new create ]

  # GET /tasks or /tasks.json
  def index
    tasks = TaskService.new(resource: @parent).grouped_tasks

    @not_started_tasks = tasks.fetch("not_started", [])
    @completed_tasks = tasks.fetch("completed", [])
    @cancelled_tasks = tasks.fetch("cancelled", [])
    @in_progress_tasks = tasks.fetch("in_progress", [])
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = @parent.tasks.build
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = @parent.tasks.build(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to [ @parent, @task ], notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to [ @parent, @task ], notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to polymorphic_path([ @parent, :tasks ]), status: :see_other, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = @parent.tasks.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.expect(task: [ :title, :description, :priority, :status, :due_date, :business_id, :team_id, :assigned_to_id, :started_at, :completed_at ])
    end

    def set_parent
      if params[:business_id].present?
        @parent = Business.includes(:tasks).find(params[:business_id])
      elsif params[:team_id].present?
        @parent = Team.includes(:tasks).find(params[:team_id])
      else
        # Handle case where no parent ID is provided, perhaps raise an error or redirect
        # For now, let's assume one will always be present due to routes setup.
        # If not, this would indicate an invalid route access.
        flash[:alert] = "Invalid access: Task requires a business or team context."
        redirect_to root_path and return
      end
    end
end
