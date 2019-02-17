import axios from 'axios'

export function convertTaskData(data) {
	return {
		id: data.id,
		storyId: data.story_id,
		name: data.name,
		completed: data.completed
	};
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
				successFunction(convertTaskData(response.data));
			})
			.catch(function(error) {
				errorFunction(error);
			});
	}

	//update
	return axios.put(`/task_tracker/tasks/${taskId}.json`, localTask)
		.then(function(response) {
			successFunction(convertTaskData(response.data));
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