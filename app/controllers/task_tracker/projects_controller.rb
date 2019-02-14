class TaskTracker::ProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_project, only: [:show, :update, :destroy]

  # GET /task_tracker/projects/1
  # GET /task_tracker/projects/1.json
  def show
  end

  # POST /task_tracker/projects
  # POST /task_tracker/projects.json
  def create
    @project = TaskTracker::Project.new(project_params)

    if @project.save
      render :show, status: :created, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /task_tracker/projects/1
  # PATCH/PUT /task_tracker/projects/1.json
  def update
    if @project.update(project_params)
      render :show, status: :ok, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /task_tracker/projects/1
  # DELETE /task_tracker/projects/1.json
  def destroy
    @project.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = TaskTracker::Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:user_id, :name, :description)
    end
end
