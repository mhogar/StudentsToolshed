<template>
	<div class="ui segments">
		<div v-bind:class="'ui segment ' + (task.completed ? 'green task-complete' : 'yellow task-todo')">
			<div class="ui grid">
				<div class="left floated twelve wide column">
					<div v-if="state === ''">
						<i class="thumbtack icon"></i> {{task.name}}
					</div>
					<EditForm v-if="state !== ''"
						v-bind:saveFunc="function(event) { state !== '' && update(event) }"
						v-bind:discardFunc="function(event) {state === 'create' ? destroy(event) : state = ''}"
						v-bind:model="editTask"
						v-bind:id_name="'task-name-input-'">
					</EditForm>
				</div>
				<div class="left floated two wide column">
					<div class="ui checkbox right floated">
						<input type="checkbox" v-on:click.prevent="toggleDone($event)" v-bind:checked="task.completed">
						<label>Completed</label>
					</div>
				</div>
				<div class="left floated one wide column">
					<EditMenu v-bind:editFunc="edit" v-bind:deleteFunc="destroy"></EditMenu>
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
				state: this.task.name === '' ? 'create' : '',
				editTask: this.task
			};
		},
		methods: {
			toggleDone: function (event) {
				this.task.completed = !this.task.completed;
				this.$parent.updateProgressBar();

				if (this.state !== 'create') {
					Api.createOrUpdateTask(this.task);
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

				let newTask = Api.createOrUpdateTask(this.task);
				this.task.id = newTask.id;
			},
			destroy: function(event) {
				this.$parent.deleteFromTasks(this.task.id);
				Api.deleteTask(this.task.id);
			}
		}
	};
</script>