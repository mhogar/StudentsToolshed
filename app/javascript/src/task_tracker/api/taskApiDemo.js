var taskData = [];

function nextId() {
	return taskData.length > 0 ? (taskData.sort((a, b) => a.id - b.id))[taskData.length - 1].id + 1 : 0;
}

function findTask(taskId) {
	return taskData.findIndex(item => item.id === taskId);
}

export function getTasksByStoryId(storyId) {
	return taskData.filter(task => task.storyId === storyId);
}

export function createOrUpdateTask(task, successFunction, errorFunction) {
	let localTask = {};
	localTask.id = task.id;
	localTask.storyId = task.storyId;
	localTask.name = task.name;
	localTask.completed = task.completed;
	
	//create
	if (localTask.id === -1) {
		localTask.id = nextId();
		localTask.isNew = true;
		taskData.push(localTask);

		successFunction(localTask);
		return;
	}

	let index = findTask(localTask.id);
	if (index !== -1) {
		taskData[index] = localTask;

		successFunction(localTask);
		return;
	}

	errorFunction('Task with id ' + localTask.id + ' not found.');
}

export function deleteTask(taskId, successFunction, errorFunction) {
	if (taskId === -1){
		return;
	}

	let index = findTask(taskId);
	if (index !== -1) {
		delete taskData[index];
		successFunction('success');
		return;
	}

	errorFunction('Task with id ' + taskId + ' not found.');
}