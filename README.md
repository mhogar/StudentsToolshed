# Students Toolshed

## About 

### Overview
ST is a ruby on rails web application that is composed of smaller javascript applications. The outer container part is refered to as Fractal (because of its app made of apps ception), providing authentication, navigation, an API, database, etc. for each of its javascript apps. The apps themseleves are small, useful tools targeted for use by university students.

### Inspiration
Have you ever had a great idea for a small but useful app on the bus ride home? Were you demotivated by all the background work that needs to be done to make your app even run? Well no more, as ST’s infrastructure was designed in such a way that adding new apps is quick and easy. All the “hard” stuff is already provided by the ST, so you can get straight to creating your app without having to setup any of that background stuff.

### Available apps
As of the current release there is only one app, however more are planned. Look forward to Course Scheduler, Grade Calculator, and Credit Tracker!

- __Task Tracker__: Create projects, stories, and tasks to help organize and guide your thoughts in this easy to use task management app.

## Running the App

### Building and setup
1. ST is run using docker compose. Install it [here](https://docs.docker.com/compose/install/)
1. Fork/download the repo and open a terminal in the root directory of the app. Run `docker-compose build`
1. Run `docker-compose run app rails db:migrate` to finish database setup

### Running the server
- Start the container and run the server with `docker-compose up`. Navigate to http://localhost:3000

### Running the tests
- Run the rails tests with `docker-compose run app rails test`
- To run specific tests, add the following to the end of the command:
    - Model validation tests: `test/models/*`
    - API endpoint controller tests: `test/controllers/*`

## Release Notes
- [Fractal](https://github.com/mhogar/StudentsToolshed/wiki/Fractal-Release-Notes)
- [Task Tracker](https://github.com/mhogar/StudentsToolshed/wiki/Task-Tracker-Release-Notes)
