import axios from 'axios'

function createPromise(promise, successFunction, errorFunction) {
	return promise.then(function (response) {
		let srcData = response.data;
		let data = {
			userId: srcData.user_id
    		name: srcData.name,
    		description: srcData.description
		}

		successFunction(data);
	}).catch(errorFunction);
}

export function getProjectStats(successFunction, errorFunction) {
	return createPromise(axios.get('/task_tracker/project_stats.json'), successFunction, errorFunction);
}

export function getProjectById(id, successFunction, errorFunction) {
	return createPromise(axios.get(`/task_tracker/projects/${id}.json`), successFunction, errorFunction);
}

export function createProject(project, successFunction, errorFunction) {
	let localProject = {
  		user_id: project.user_id
    	name: project.name,
    	description: project.description
	};

	return createPromise(axios.post('/task_tracker/projects.json', localProject), successFunction, errorFunction);
}

export function updateProject(project, successFunction, errorFunction) {
	var projectId = project.id;
	var localProject = {
  		user_id: project.user_id
    	name: project.name,
    	description: project.description
	};

	return createPromise(axios.put(`/task_tracker/projects/${projectId}.json`, localProject), successFunction, errorFunction);
}

export function deleteProject(projectId, successFunction, errorFunction) {
	return createPromise(axios.delete(`/task_tracker/projects/${projectId}.json`), successFunction, errorFunction);
}