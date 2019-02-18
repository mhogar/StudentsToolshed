class TaskTracker::StoriesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_story, only: [:show, :update, :destroy]
  before_action :set_user
  before_action :require_same_user, except: [:create]

  # GET /task_tracker/stories/1.json
  def show
  end

  # POST /task_tracker/stories.json
  def create
    @story = TaskTracker::Story.new(story_params)
    @story.fractal_interface = @user.task_tracker_interface

    if @story.save
      render :show, status: :created, location: @story
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  # PUT /task_tracker/stories/1.json
  def update
    if @story.update(story_params)
      render :show, status: :ok, location: @story
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  # DELETE /task_tracker/stories/1
  # DELETE /task_tracker/stories/1.json
  def destroy
    @story.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = TaskTracker::Story.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_params
      params.require(:story).permit(:project_id, :name)
    end

    def set_user
      if not user_signed_in?
        render json: { error: 'A user is not signed in' }, status: :unauthorized
      end

      @user = current_user
    end

    def require_same_user
      if @user != @story.fractal_interface.user
        render json: { error: 'You are authorized to access this story' }, status: :unauthorized
      end
    end
end
