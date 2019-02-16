import axios from 'axios'

function createPromise(promise, successFunction, errorFunction) {
	return promise.then(function (response) {
		let srcData = response.data;
		let data = {
			storyId: srcData.story_id,
			name: srcData.name,
			completed: srcData.completed
		}

		successFunction(data);
	}).catch(errorFunction);
}

export function getTasksByStoryId(storyId, successFunction, errorFunction) {
	return createPromise(axios.get(`/task_tracker/tasks/?story_id=${storyId}`), successFunction, errorFunction);
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
		return createPromise(axios.post('/task_tracker/tasks.json', localTask), successFunction, errorFunction);
	}

	//update
	return createPromise(axios.put(`/task_tracker/tasks/${taskId}.json`, localTask), successFunction, errorFunction);
}

export function deleteTask(taskId, successFunction, errorFunction) {
	return createPromise(axios.delete(`/task_tracker/tasks/${taskId}.json`), successFunction, errorFunction);
}