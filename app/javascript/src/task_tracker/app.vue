<template>
	<div>
		<div v-if="loading" class="ui basic segment">
			<div class="ui active inverted dimmer">
				<div class="ui text loader">Loading</div>
			</div>
		</div>
		<div v-else>
			<div class="ui three cards" v-if="selectedProject === null">
				<ProjectCard class="ui cards" v-for="project in projects" :key="project.id" v-bind:project="project"></ProjectCard>
				<div class="ui link raised card" v-on:click="createProject($event)">
					<div class="content">
						<i class ="icon plus circle"></i> Add a new project
					</div>
				</div>
			</div>
			<Project v-bind:projectId="selectedProject.id" v-else></Project>
		</div>
	</div>
</template>

<script>
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
				selectedProject: null
			};
		},
		methods: {
			showView: function() {
				this.selectedProject = null;
				window.scrollTo(0, 0);

				this.loadProjects();
			},
			loadProjects: function(callback = null) {
				this.loading = true;
				Api.getProjectStats(function(data) {
					this.projects = data;

					if (callback !== null) {
						callback();
					} else {
						this.loading = false;
					}
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
				this.loading = true;
				Api.createProject(
					{
						userId: 1,
						name: 'New Project',
						description: ''
					},
					function(data) {
						this.loadProjects(function() {
							let index = this.projects.findIndex(item => item.id === data.id);
							if (index !== -1) {
								this.projects[index].isNew = true;
							}
							this.loading = false;
						}.bind(this));
					}.bind(this),
					function(error) {
						console.log(error);
					}
				);
			},
			deleteFromProjects: function(projectId) {
				let index = this.projects.findIndex(item => item.id === projectId);
				if (index !== -1) {
					this.loading = true;
					Api.deleteProject(
						projectId,
						function(response) {
							this.$delete(this.projects, index);
							this.loading = false;
						},
						function(error) {
							console.log(error);
						}
					);
				}
			}
		},
		beforeMount: function() {
			this.loadProjects();
		}
	};
</script>