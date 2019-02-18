<template>
	<div class="ui link raised card" v-on:click="$parent.selectProject(project)">
		<div class="content">
			<div class="ui grid">
				<div class="twelve wide column">
					<div class="ui header">
					  	<i v-bind:class="'icon ' + (project.percent === 100 ? 'check circle green' : 'yellow thumbtack')"></i>
					  	<div class="content">
					    	{{project.name}}
					    	<div class="sub header">{{project.description}}</div>
					  	</div>
					</div>
				</div>
				<div class="right floated three wide column" v-if="isEmpty">
					<div class="ui icon basic circular button" v-on:click.stop="discardCreate($event)">
						<i class="remove icon"></i>
					</div>
				</div>
			</div>
		</div>
		<div class="content">
			<div class="ui horizontal list">
				<div class="item">Stories: <b>{{project.numStories}}</b></div>
				<div class="item">Tasks: <b>{{project.numTasks}}</b></div>
			</div>
		</div>
		<div class="extra content">
			Completion: {{project.percent}}%
		</div>
		<div class="ui bottom attached indicating progress" v-bind:id="progressBarId">
		    <div class="bar"></div>
	  	</div>
	</div>
</template>

<script>
	export default {
		props: ['project'],
		computed: {
			progressBarId: function() {
				return 'project-progress-bar-' + this.project.id;
			},
			isEmpty: function() {
				return this.project.numStories == 0 && this.project.numTasks == 0
			}
		},
		methods: {
			updateProgressBar: function() {
				$('#' + this.progressBarId).progress({
					percent: this.project.percent
				});
			},
			discardCreate: function(event) {
				this.$parent.deleteFromProjects(this.project.id)
			}
		},
		mounted: function() {
			this.updateProgressBar();
		},
		updated: function() {
			this.updateProgressBar();
		}
	};
</script>