import { getStoriesByProjectId } from './storyApiDemo';

var projectData = [];

function nextId() {
	return projectData.length > 0 ? (projectData.sort((a, b) => a.id - b.id))[projectData.length - 1].id + 1 : 0;
}

function findProject(projectId) {
	return projectData.findIndex(item => item.id === projectId);
}

export function getProjectStats(successFunction, errorFunction) {
	let projectStats = [];

	projectData.forEach((project) => {
		let stats = {};
		stats.id = project.id;
		stats.name = project.name;
		stats.description = project.description;

		let stories = getStoriesByProjectId(project.id);
		stats.numStories = stories.length;

		stats.numTasks = 0;
		stats.percent = 0;

		stories.forEach((story) => {
			stats.numTasks += story.tasks.length;
			stats.percent += story.tasks.filter((task) => task.completed === true).length;
		});

		if (stats.percent > 0) {
			stats.percent = Math.round(stats.percent / stats.numTasks * 100);
		}

		projectStats.push(stats);
	});

	successFunction(projectStats);
}

export function getProjectById(projectId, successFunction, errorFunction) {
	let index = findProject(projectId);
	if (index !== -1) {
		let project = projectData[index];
		project.stories = getStoriesByProjectId(project.id);

		successFunction(project);
		return;
	}

	errorFunction('Project with id ' + projectId + ' not found.');
}

export function createProject(project, successFunction, errorFunction) {
	let localProject = {};
	localProject.id = nextId();
	localProject.name = project.name;
	localProject.description = project.description;

	projectData.push(localProject);

	successFunction(localProject);
}

export function updateProject(project, successFunction, errorFunction) {
	let index = findProject(project.id);
	if (index !== -1) {
		let localProject = {};
		localProject.id = project.id;
		localProject.name = project.name;
		localProject.description = project.description;

		projectData[index] = localProject;

		successFunction(localProject);
		return;
	}

	errorFunction('Project with id ' + project.id + ' not found.');
}

export function deleteProject(projectId, successFunction, errorFunction) {
	let index = findProject(projectId);
	if (index !== -1) {
		projectData.splice(index, 1);

		successFunction('success');
		return;
	}

	errorFunction('Project with id ' + projectId + ' not found.');
}