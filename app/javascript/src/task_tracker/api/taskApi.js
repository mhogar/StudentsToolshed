import axios from 'axios'

function sanitizeData(data) {
	return {
		storyId: data.story_id,
		name: data.name,
		completed: data.completed
	};
}

export function getTasksByStoryId(storyId, successFunction, errorFunction) {
	return axios.get(`/task_tracker/tasks/?story_id=${storyId}`)
		.then(function(response) {
			response.data.forEach((item, index, array) => array[index] = datsanitizeData(item))
			successFunction(response.data);
		})
		.catch(function(error) {
			errorFunction(error);
		});
}

export function createOrUpdateTask(task, successFunction, errorFunction) {
	let taskId = task.id;
	let localTask = {
		story_id: task.storyId,
		name: task.name,
		completed: task.completed
	};
	
	//create
	if (taskId === -1) {
		return axios.post('/task_tracker/tasks.json', localTask)
			.then(function(response) {
				successFunction(sanitizeData(response.data));
			})
			.catch(function(error) {
				errorFunction(error);
			});
	}

	//update
	return axios.put(`/task_tracker/tasks/${taskId}.json`, localTask)
		.then(function(response) {
			successFunction(sanitizeData(response.data));
		})
		.catch(function(error) {
			errorFunction(error);
		});
}

export function deleteTask(taskId, successFunction, errorFunction) {
	return axios.delete(`/task_tracker/tasks/${taskId}.json`)
		.then(function(response) {
			successFunction('success');
		})
		.catch(function(error) {
			errorFunction(error);
		});
}