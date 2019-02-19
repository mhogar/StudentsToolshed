import { getTasksByStoryId } from './taskApiDemo';

var storyData = [];

function nextId() {
	return storyData.length > 0 ? (storyData.sort((a, b) => a.id - b.id))[storyData.length - 1].id + 1 : 0;
}

function findStory(storyId) {
	return storyData.findIndex(item => item.id === storyId);
}

export function getStoriesByProjectId(projectId) {
	let stories = storyData.filter(story => story.projectId === projectId);
	stories.forEach((story) => story.tasks = getTasksByStoryId(story.id));

	return stories;
}

export function createOrUpdateStory(story, successFunction, errorFunction) {
	let localStory = {};
	localStory.id = story.id;
	localStory.projectId = story.projectId;
	localStory.name = story.name;
	localStory.description = story.description;

	//create
	if (localStory.id === -1) {
		localStory.id = nextId();

		storyData.push(localStory);

		successFunction(localStory);
		return;
	}

	let index = findStory(localStory.id);
	if (localStory !== -1) {
		storyData[localStory] = localStory;

		successFunction(localStory);
		return;
	}

	errorFunction('Story with id ' + localStory.id + ' not found.');
}

export function deleteStory(storyId, successFunction, errorFunction) {
	if (storyId === -1) {
		return;
	}

	let index = findStory(storyId);
	if (index !== -1) {
		delete storyData[index];
		successFunction('success');
		return;
	}

	errorFunction('Story with id ' + storyId + ' not found.');
}