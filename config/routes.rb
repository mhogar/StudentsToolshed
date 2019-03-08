Rails.application.routes.draw do
  devise_for :users
  root 'fractal#home'
  
  get 'about', to: 'fractal#about'
  
  get 'task_tracker', to: 'task_tracker#index'
  namespace :task_tracker do
  	resources :tasks, :stories, :projects, except: [:index]
  	get 'project_stats', to: 'projects#stats'
  end
end
