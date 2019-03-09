<template>
	<div>
		<div v-if="loading" class="ui active inverted dimmer">
			<div class="ui loader"></div>
		</div>
		<div class="ui three cards" v-if="selectedProject === null">
			<ProjectCard class="ui cards" v-for="project in projects" :key="project.id" v-bind:project="project"></ProjectCard>
			<div class="ui link raised card" v-on:click="createProject($event)">
				<div class="content">
					<i class ="icon plus circle"></i> Add a new project
				</div>
			</div>
		</div>
		<Project v-else v-bind:projectId="selectedProject.id"></Project>
	</div>
</template>

<script>
	/*global config*/
	
	const Api = require('./api/projectApi');

	import projectComponent from './components/project.vue'
	import projectCardComponent from './components/projectCard.vue'

	export default {
		components: {
			'Project': projectComponent,
			'ProjectCard': projectCardComponent
		},
		data: function() {
			return {
				loading: false,
				projects: [],
				loadingProjectIndex: -1,
				selectedProject: null
			};
		},
		methods: {
			showView: function() {
				this.selectedProject = null;
				window.scrollTo(0, 0);

				if (this.loadingProjectIndex < 0) {
					this.loadProjects();
				}
			},
			loadProjects: function() {
				this.loading = true;
				Api.getProjectStats(function(data) {
					this.projects = data;
					this.loading = false;
				}.bind(this),
				function(error) {
					console.log(error);
				});
			},
			selectProject: function(project) {
				this.selectedProject = project;
				window.scrollTo(0, 0);
			},
			createProject: function(event) {
				this.addLoadingProject(this.projects.length);
				Api.createProject(
					{
						name: 'New Project',
						description: ''
					},
					function(data) {
						data.numStories = 0;
						data.numTasks = 0;
						data.totalTimeEstiamte = 0;
						data.remainingTimeEstimate = 0;
						
						if (!config.demoMode) {
							data.createdDate = new Date();
							data.updatedDate = new Date();
						}

						this.projects.push(data);
						this.removeLoadingProject();
					}.bind(this),
					function(error) {
						console.log(error);
					}
				);
			},
			deleteFromProjects: function(projectId) {
				let index = this.projects.findIndex(item => item.id === projectId);
				if (index !== -1) {
					this.$delete(this.projects, index);
					this.addLoadingProject(index);
					Api.deleteProject(
						projectId,
						function(response) {
							this.removeLoadingProject();
						}.bind(this),
						function(error) {
							console.log(error);
						}
					);
				}
			},
			addLoadingProject: function(index) {
				this.loadingProjectIndex = index;
				this.projects.splice(index, 0, { loading: true });
			},
			removeLoadingProject: function() {
				this.$delete(this.projects, this.loadingProjectIndex);
				this.loadingProjectIndex = -1;
			}
		},
		beforeMount: function() {
			this.loadProjects();
		}
	};
</script>