# About Fractal

### Overview
Fractal is a ruby on rails web application that is composed of smaller javascript applications. The rails app acts as a container, providing authentication, navigation, an API, database, etc. for each of its javascript apps. 

### Inspiration
Have you ever had a great idea for a small but useful app on the bus ride home? Were you demotivated by all the background work that needs to be done to make your app even run? Well no more, as Fractal’s infrastructure was designed in such a way that adding new apps is quick and easy. All the “hard” stuff is already provided by the Fractal, so you can get straight to creating your app without having to setup any of that background stuff.

### Available apps
As of the current release there is only one app, however more are planned. Look forward to Course Scheduler, Grade Calculator, and Credit Tracker!

* __Task Tracker__: Create projects, stories, and tasks to help organize and guide your thoughts in this easy to use task management app.

# Running the app

### System Dependencies
* rails 5.2.2
* ruby 2.6.1
* bundler 2.0.1
* yarn

### Setting up the app locally
1. run `yarn install` to install front-end packages used by the javascript apps
1. run `bundle install –-without production`
1. run `rails db:migrate`

### Running the server
* run `rails server`

### Running the tests
* Each model has associated validation tests. Run them with `rails test test/models/*`
* Each API endpoint has associated integration tests. Run them with `rails test test/controllers/*`

# Release Notes
* [Task Tracker](release_notes/task_tracker.md)
