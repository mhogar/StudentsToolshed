import apiHelper for 'api_helper'

export function getProjectStats(successFunction, errorFunction) {
	return apiHelper.createPromise(axios.get('/task_tracker/project_stats.json'), successFunction, errorFunction);
}

export function getProjectById(id, successFunction, errorFunction) {
	return apiHelper.createPromise(axios.get(`/task_tracker/projects/${id}.json`), successFunction, errorFunction);
}

export function createProject(project, successFunction, errorFunction) {
	let localProject = project;
  delete localProject.id;
  
  return apiHelper.createPromise(axios.post('/task_tracker/projects.json', localProject), successFunction, errorFunction);
}

export function updateProject(project, successFunction, errorFunction) {
	var projectId = project.id;
  var localProject = {
  	user_id: project.user_id
    name: project.name,
    description: project.description
	};

	return apiHelper.createPromise(axios.put(`/task_tracker/projects/${projectId}.json`, localProject), successFunction, errorFunction);
}

export function deleteProject(projectId, successFunction, errorFunction) {
	return apiHelper.createPromise(axios.delete(`/task_tracker/projects/${projectId}.json`), successFunction, errorFunction);
}