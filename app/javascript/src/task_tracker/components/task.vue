<template>
	<div class="ui segments">
		<div v-bind:class="'ui segment ' + (task.completed ? 'green task-complete' : 'yellow task-todo')">
			<div v-if="loading" class="ui active inverted dimmer">
				<div class="ui loader"></div>
			</div>
			<div class="ui grid">
				<div class="left floated twelve wide column">
					<div v-if="state === ''">
						<i class="thumbtack icon"></i> {{task.name}}
					</div>
					<EditForm v-else
						v-bind:saveFunc="function(event) { state !== '' && update(event) }"
						v-bind:discardFunc="function(event) {state === 'create' ? discardCreate(event) : state = ''}"
						v-bind:model="editTask"
						v-bind:id_name="'task-name-input-'"
						v-bind:validations="{ required: true, minLength: config.minNameLength, maxLength: config.maxNameLength }">
					</EditForm>
				</div>
				<div class="left floated two wide column">
					<div class="ui checkbox right floated">
						<input type="checkbox" v-on:click.prevent="toggleDone($event)" v-bind:checked="task.completed">
						<label>Completed</label>
					</div>
				</div>
				<div class="left floated one wide column">
					<EditMenu 
						v-bind:editFunc="edit" 
						v-bind:deleteFunc="destroy" 
						v-bind:options="{ menuPointDir: 'top left' }">
					</EditMenu>
				</div>
			</div>
		</div>
	</div>
</template>

<style>
	.task-todo {
		background-color: lightgoldenrodyellow !important;
	}

	.task-complete {
		background-color: palegreen !important;
	}
</style>

<script>
	const Api = require('../api/taskApi');

	import editMenuComponent from './editMenu.vue';
	import editFormComponent from './editForm.vue';

	export default {
		props: ['task'],
		components: {
			'EditMenu': editMenuComponent,
			'EditForm': editFormComponent
		},
		data: function() {
			return {
				loading: false,
				state: this.task.name === '' ? 'create' : '',
				editTask: this.task
			};
		},
		computed: {
			config: function() {
				return taskConfig;
			}
		},
		methods: {
			toggleDone: function (event) {
				this.task.completed = !this.task.completed;
				this.$parent.updateProgressBar();

				if (this.state !== 'create') {
					this.loading = true;
					Api.createOrUpdateTask(
						this.task,
						function(data) {
							this.loading = false;
						}.bind(this),
						function(error) {
							console.log(error);
						}
					);
				}
			},
			edit: function(event) {
				if (this.state === 'create') {
					return;
				}

				this.state = 'edit';

				this.editTask = {
					id: this.task.id,
					name: this.task.name
				};
			},
			update: function(event) {
				this.state = '';

				this.task.name = this.editTask.name;

				this.loading = true;
				Api.createOrUpdateTask(
					this.task,
					function(data) {
						let newTask = data;
						this.task.id = newTask.id;
						this.loading = false;
					}.bind(this),
					function(error) {
						console.log(error);
					}
				);
			},
			discardCreate: function(event) {
				this.$parent.deleteFromTasks(this.task.id);
			},
			destroy: function(event) {
				this.loading = true;
				Api.deleteTask(
					this.task.id,
					function(response) {
						this.$parent.deleteFromTasks(this.task.id);
						this.loading = false;
					}.bind(this),
					function(error) {
						console.log(error);
					}
				);
			}
		}
	};
</script>