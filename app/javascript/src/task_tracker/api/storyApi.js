import axios from 'axios'

function createPromise(promise, successFunction, errorFunction) {
	return promise.then(function (response) {
		let srcData = response.data;
		let data = {
			projectId: srcData.project_id,
			name: srcData.name
		}

		successFunction(data);
	}).catch(errorFunction);
}

export function getStoriesByProjectId(projectId, successFunction, errorFunction) {
	return createPromise(axios.get(`/task_tracker/stories/?project_id=${projectId}`), successFunction, errorFunction);
}

export function createOrUpdateStory(story, successFunction, errorFunction) {
	let storyId = story.id;
	let localStory = {
		project_id: story.projectId,
		name: story.name
	};

	//create
	if (storyId === -1) {
	  return createPromise(axios.post('/task_tracker/stories.json', localStory), successFunction, errorFunction);
	}

	//update
	return createPromise(axios.put(`/task_tracker/stories/${storyId}.json`, localStory), successFunction, errorFunction);
}

export function deleteStory(storyId, successFunction, errorFunction) {
	return createPromise(axios.delete(`/task_tracker/stories/${storyId}.json`), successFunction, errorFunction);
}