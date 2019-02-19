class TaskTrackerController < ApplicationController
  def index
  	@demoMode = (not user_signed_in?)
  end
end
