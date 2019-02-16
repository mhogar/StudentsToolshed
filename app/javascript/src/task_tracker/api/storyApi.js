import axios from 'axios'
import { convertTaskData } from './taskApi';

export function convertStoryData(data) {
	let newData = {
		id: data.id,
		projectId: data.project_id,
		name: data.name
	};

	newData.tasks = [];
	data.tasks.forEach((task) => newData.tasks.push(convertTaskData(task)));

	return newData;
}

export function getStoriesByProjectId(projectId, successFunction, errorFunction) {
	return axios.get(`/task_tracker/stories/?project_id=${projectId}`)
		.then(function(response) {
			response.data.forEach((item, index, array) => array[index] = convertStoryData(item))
			successFunction(response.data);
		})
		.catch(function(error) {
			errorFunction(error);
		});
}

export function createOrUpdateStory(story, successFunction, errorFunction) {
	let storyId = story.id;
	let localStory = {
		project_id: story.projectId,
		name: story.name
	};

	//create
	if (storyId === -1) {
	  return axios.post('/task_tracker/stories.json', localStory)
		  .then(function(response) {
				successFunction(convertStoryData(response.data));
			})
			.catch(function(error) {
				errorFunction(error);
			});
	}

	//update
	return axios.put(`/task_tracker/stories/${storyId}.json`, localStory)
		.then(function(response) {
			successFunction(convertStoryData(response.data));
		})
		.catch(function(error) {
			errorFunction(error);
		});
}

export function deleteStory(storyId, successFunction, errorFunction) {
	return axios.delete(`/task_tracker/stories/${storyId}.json`)
		.then(function(response) {
			successFunction('success');
		})
		.catch(function(error) {
			errorFunction(error);
		});
}