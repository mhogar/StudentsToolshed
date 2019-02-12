Rails.application.routes.draw do
  devise_for :users
  root 'welcome#home'
  
  get 'task_tracker', to: 'task_tracker#index'
  namespace :task_tracker do
  	resources :tasks, :stories, :projects, except: [:index]
  end
end
