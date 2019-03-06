class TaskTracker::ProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_project, only: [:show, :update, :destroy]
  before_action :set_user
  before_action :require_same_user, except: [:stats, :create]

  def stats
    @project_stats = []

    @user.task_tracker_interface.projects.each do |project|
      stats = {}

      stats[:id] = project.id
      stats[:name] = project.name
      stats[:description] = project.description
      stats[:created_date] = project.created_at

      stories = project.stories.select(:id, :updated_at).order(updated_at: :desc)
      stats[:num_stories] = stories.length

      tasks = @user.task_tracker_interface.tasks.select(:completed, :time_estimate, :updated_at).where(story_id: stories.ids).order(updated_at: :desc)
      stats[:num_tasks] = tasks.length
      stats[:remaining_time_estimate] = 0
	  	stats[:total_time_estiamte] = 0
	  	
	  	tasks.each do |task|
	  	  stats[:total_time_estiamte] += task.time_estimate
				stats[:remaining_time_estimate] += (!task.completed ? task.time_estimate : 0)
	  	end

      lastStoryUpdate = stories.length > 0 ? stories[0].updated_at : Time.zone.parse('0001-01-01 00:00:00')
      lastTaskUpdate = tasks.length > 0 ? tasks[0].updated_at : Time.zone.parse('0001-01-01 00:00:00')
      stats[:updated_date] = [project.updated_at, lastStoryUpdate, lastTaskUpdate].max

      @project_stats.append(stats)
    end

    #sort by last updated desc
    @project_stats.sort! { |a, b| b[:updated_date] <=> a[:updated_date] }
  end

  # GET /task_tracker/projects/1
  # GET /task_tracker/projects/1.json
  def show
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
    @project.fractal_interface = @user.task_tracker_interface

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

    def require_same_user
      if @user != @project.fractal_interface.user
        render json: { error: 'You are authorized to access this project' }, status: :unauthorized
      end
    end
end
