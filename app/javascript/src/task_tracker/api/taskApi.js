import apiHelper for 'api_helper'

export function getTasksByStoryId(storyId, successFunction, errorFunction) {
	return apiHelper.createPromise(axios.get(`/task_tracker/tasks/?story_id=${storyId}`), successFunction, errorFunction);
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
		return apiHelper.createPromise(axios.post('/task_tracker/tasks.json', localTask), successFunction, errorFunction);
	}

	//update
	return apiHelper.createPromise(axios.put(`/task_tracker/tasks/${taskId}.json`, localTask), successFunction, errorFunction);
}

export function deleteTask(taskId, successFunction, errorFunction) {
	return apiHelper.createPromise(axios.delete(`/task_tracker/tasks/${taskId}.json`), successFunction, errorFunction);
}