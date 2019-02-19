<template>
	<div>
		<div v-if="loading" class="ui active inverted dimmer">
			<div class="ui loader"></div>
		</div>
		<div v-if="firstLoad">
			<div class="ui grid">
				<div class="twelve wide column">
					<h2 class="ui header" v-if="state === ''">
					  	<i class="folder open icon"></i>
					  	<div class="content">
					    	{{project.name}}
					    	<div class="sub header">{{project.description}}</div>
					  	</div>
					</h2>
					<ProjectEditForm v-else
						v-bind:saveFunc="function(event) { update(event) }"
						v-bind:discardFunc="function(event) {state = ''}"
						v-bind:model="editProject">
					</ProjectEditForm>
				</div>
				<div class="right floated three wide column">
					<button class="ui labeled icon purple button" v-on:click="createStory($event)">
					  <i class="plus icon"></i>
					  Add a new story
					</button>
				</div>
				<div class="one wide column">
					<EditMenu 
						v-bind:editFunc="edit" 
						v-bind:deleteFunc="destroy" 
						v-bind:options="{ confirmDelete: deleteConfirmLevel, confirmDeleteMessage: deleteConfirmMessage, menuPointDir: 'top right' }">
					</EditMenu>
				</div>
			</div>
			<h2 class="ui center aligned header" id="no-stories-message" v-if="!project.stories.length">
			  <span class="sub header">You don't have any stories yet. Create some.</span>
			</h2>
			<Story v-for="story in project.stories" :key="story.id" v-bind:story="story"></Story>
			<button class="ui labeled icon teal button" id="back-button" v-on:click="goBackToProjectSelect()">
				<i class="ui icon arrow left"></i> Back
			</button>
		</div>
	</div>
</template>

<style scoped>
	#back-button {
		margin-top: 0.5em;
	}

	#no-stories-message {
		padding-top: 3em;
		padding-bottom: 3em;

		background: #e9e9e9;
		border-radius: 10px;
	}
</style>

<script>
	const Api = require('../api/projectApi');

	import storyComponent from './story.vue';
	import editMenuComponent from './editMenu.vue';
	import projectEditFormComponent from './projectEditForm.vue';

	export default {
		props: ['projectId'],
		components: {
			'Story': storyComponent,
			'EditMenu': editMenuComponent,
			'ProjectEditForm': projectEditFormComponent
		},
		data: function() {
			return {
				firstLoad: false,
				loading: false,
				state: '',
				project: {},
				editProject: {}
			};
		},
		computed: {
			config: function() {
				return projectConfig;
			},
			numStories: function () {
				let stories = this.project.stories;
				return stories ? stories.length : 0;
			},
			deleteConfirmLevel: function() {
				let DELETE_CONFIRM_LEVEL = editMenuComponent.data().DELETE_CONFIRM_LEVEL;
				return this.numStories > 0 ? DELETE_CONFIRM_LEVEL.EXTRA : DELETE_CONFIRM_LEVEL.NORMAL;
			},
			deleteConfirmMessage: function() {
				let msg = 'Are you sure you want to this project';
				if (this.numStories > 0) {
					msg += ' and all of its stories';
				}

				return msg + '?';
			}
		},
		methods: {
			loadProject: function() {
				this.loading = true;
				Api.getProjectById(this.projectId, function(data) {
					this.project = data;
					this.firstLoad = true;
					this.loading = false;
				}.bind(this),
				function(error) {
					console.log(error);
				});
			},
			createStory: function(event) {
				let story = {
					id: -1,
					projectId: this.projectId,
					name: '',
					tasks: []
				};

				this.project.stories.push(story);

				window.scrollTo(0, document.body.scrollHeight);
			},
			deleteFromStories: function(storyId) {
				let index = this.project.stories.findIndex(item => item.id === storyId);
				if (index !== -1) {
					this.$delete(this.project.stories, index);
				}
			},
			goBackToProjectSelect: function() {
				this.$parent.showView();
			},
			edit: function(event) {
				this.state = 'edit';

				this.editProject = {
					id: this.project.id,
					name: this.project.name,
					description: this.project.description
				};
			},
			update: function(event) {
				this.state = '';

				this.project.name = this.editProject.name;
				this.project.description = this.editProject.description;

				this.loading = true;
				Api.updateProject(
					this.project,
					function(data) {
						this.loading = false;
					}.bind(this),
					function(error) {
						console.log(error);
					}
				);
			},
			destroy: function(event) {
				this.$parent.deleteFromProjects(this.project.id);

				this.goBackToProjectSelect();
			}
		},
		beforeMount: function() {
			this.loadProject();
		}
	};
</script>
