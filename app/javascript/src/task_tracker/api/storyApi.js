import apiHelper for 'api_helper'

export function getStoriesByProjectId(projectId, successFunction, errorFunction) {
	return apiHelper.createPromise(axios.get(`/task_tracker/stories/?project_id=${projectId}`), successFunction, errorFunction);
}

export function createOrUpdateStory(story, successFunction, errorFunction) {
	let storyId = story.id;
	let localStory = {
		id: story.id,
		project_id: story.projectId,
		name: story.name,
		description: story.description
	};

	//create
	if (storyId === -1) {
	  return apiHelper.createPromise(axios.post('/task_tracker/stories.json', localStory), successFunction, errorFunction);
	}

	//update
	return apiHelper.createPromise(axios.put(`/task_tracker/stories/${storyId}.json`, localStory), successFunction, errorFunction);
}

export function deleteStory(storyId, successFunction, errorFunction) {
	return apiHelper.createPromise(axios.delete(`/task_tracker/stories/${storyId}.json`), successFunction, errorFunction);
}