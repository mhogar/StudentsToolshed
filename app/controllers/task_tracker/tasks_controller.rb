class TaskTracker::TasksController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :set_task, only: [:show, :update, :destroy]
  before_action :set_user
  before_action :require_same_user, except: [:create]

	# GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = TaskTracker::Task.new(task_params)
    @task.fractal_interface = @user.task_tracker_interface

    if @task.save
      render :show, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    if @task.update(task_params)
      render :show, status: :ok, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = TaskTracker::Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:story_id, :name, :completed)
    end

    def set_user
      if not user_signed_in?
        render json: { error: 'A user is not signed in' }, status: :unauthorized
      end

      @user = current_user
    end

    def require_same_user
      if @user != @task.fractal_interface.user
        render json: { error: 'You are authorized to access this task' }, status: :unauthorized
      end
    end
end
