import axios from 'axios'

function sanitizeData(data) {
	return {
		userId: data.user_id,
		name: data.name,
		description: data.description,
		stories: data.stories
	};
}

export function getProjectStats(successFunction, errorFunction) {
	return axios.get('/task_tracker/project_stats.json')
		.then(function(response) {
			successFunction(response.data);
		})
		.catch(function(error) {
			errorFunction(error);
		});
}

export function getProjectById(id, successFunction, errorFunction) {
	return axios.get(`/task_tracker/projects/${id}.json`)
		.then(function(response) {
			successFunction(sanitizeData(response.data));
		})
		.catch(function(error) {
			errorFunction(error);
		});
}

export function createProject(project, successFunction, errorFunction) {
	let localProject = {
  		user_id: project.userId,
    	name: project.name,
    	description: project.description
	};

	return axios.post('/task_tracker/projects.json', localProject)
		.then(function(response) {
			successFunction(sanitizeData(response.data));
		})
		.catch(function(error) {
			errorFunction(error);
		});
}

export function updateProject(project, successFunction, errorFunction) {
	var projectId = project.id;
	var localProject = {
  		user_id: project.user_id,
    	name: project.name,
    	description: project.description
	};

	return axios.put(`/task_tracker/projects/${projectId}.json`, localProject)
		.then(function(response) {
			successFunction(sanitizeData(response.data));
		})
		.catch(function(error) {
			errorFunction(error);
		});
}

export function deleteProject(projectId, successFunction, errorFunction) {
	return axios.delete(`/task_tracker/projects/${projectId}.json`)
		.then(function(response) {
			successFunction('success');
		})
		.catch(function(error) {
			errorFunction(error);
		});
}