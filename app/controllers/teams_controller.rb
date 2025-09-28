class TeamsController < ApplicationController
  before_action :set_team, only: %i[ show edit update destroy members ]
  before_action :set_users, only: %i[ new edit create update ]
  authorize_resource

  # GET /teams or /teams.json
  def index
    @teams = Team.includes(:team_memberships).all
  end

  # GET /teams/1 or /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: "Team was successfully created." }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: "Team was successfully updated." }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_path, notice: "Team was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def members
    @users = @team.users
    render json: @users.map { |user| { id: user.id, full_name: user.full_name } }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.includes(:team_memberships).find(params[:id])
    end

    def set_users
      @users = User.all.order(:first_name, :last_name)
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(
        :name,
        :description,
        user_ids: []
      )
    end
end
