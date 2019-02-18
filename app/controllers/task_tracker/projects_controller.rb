class TaskTracker::ProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token
  #before_action :set_user
  before_action :set_project, only: [:show, :update, :destroy]

  def stats
    @project_stats = []
    @user = User.first

    @user.task_tracker_interface.projects.order('id').each do |project|
      stats = {}

      stats[:id] = project.id
      stats[:name] = project.name
      stats[:description] = project.description

      story_ids = project.stories.select('id')
      stats[:num_stories] = story_ids.count

      tasks = @user.task_tracker_interface.tasks.select('completed').where(story_id: story_ids)
      stats[:num_tasks] = tasks.count
      stats[:percent] = tasks.select { |task| task.completed == true }.count

      if stats[:percent] > 0
        stats[:percent] = (stats[:percent].to_f / stats[:num_tasks]).round(2) * 100
      end

      @project_stats.append(stats)
    end
  end

  # GET /task_tracker/projects/1
  # GET /task_tracker/projects/1.json
  def show
    @user = User.first

    @stories = []
    stories = @project.stories

    story_ids = []
    stories.each { |story| story_ids << story.id }
    tasks = @user.task_tracker_interface.tasks.where(story_id: story_ids)

    stories.each do |story|
      new_story = story.attributes
      new_story[:tasks] = tasks.select { |task| task.story_id == story.id }
      @stories.append(new_story)
    end
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
      params.require(:project).permit(:name, :description)
    end

    def set_user
      if not user_signed_in?
        render json: { error: 'A user is not signed in' }, status: :unauthorized
      end

      @user = current_user
    end
end
