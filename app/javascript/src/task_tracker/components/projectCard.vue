<template>
	<div class="ui link raised card" v-on:click="$parent.selectProject(project)">
		<div class="content">
			<div class="ui grid">
				<div class="twelve wide column">
					<div class="ui header">
					  	<i v-bind:class="'icon ' + (completionPercent === 100 ? 'check circle green' : 'yellow thumbtack')"></i>
					  	<div class="content">
					    	{{project.name}}
					    	<div class="sub header">{{project.description !== '' ? project.description : 'No description'}}</div>
					  	</div>
					</div>
				</div>
				<div class="right floated three wide column">
					<div v-bind:class="'ui icon small basic circular button' + (!isEmpty ? ' disabled' : '')" v-on:click.stop="discardCreate($event)">
						<i class="remove icon"></i>
					</div>
				</div>
			</div>
		</div>
		<div class="content">
			<div class="ui list">
				<div class="item">
					<div class="ui horizontal list">
						<div class="item"><strong>Stories:</strong> {{project.numStories}}</div>
						<div class="item"><strong>Tasks:</strong> {{project.numTasks}}</div>
						<div class="item"><strong>Total Time:</strong> {{project.totalTimeEstiamte}}h</div>
					</div>
				</div>
				<div v-if="!inDemoMode" class="item"><strong>Created:</strong> {{createDateTimeString(project.createdDate)}}</div>
				<div v-if="!inDemoMode" class="item"><strong>Updated:</strong> {{createDateTimeString(project.updatedDate)}}</div>
			</div>
		</div>
		<div class="extra content">
			<div class="ui middle aligned list">
				<div class="item">
					Completion: {{completionPercent}}%
					<div class="right floated content"> Remaining: {{project.remainingTimeEstimate}}h</div>
				</div>
			</div>
		</div>
		<div class="ui bottom attached indicating progress" v-bind:id="progressBarId">
		    <div class="bar"></div>
	  	</div>
	</div>
</template>

<script>
	/*global config*/

	export default {
		props: ['project'],
		computed: {
			inDemoMode: function() {
				return config.demoMode;
			},
			progressBarId: function() {
				return 'project-progress-bar-' + this.project.id;
			},
			isEmpty: function() {
				return this.project.numStories == 0 && this.project.numTasks == 0
			},
			completionPercent: function() {
				return this.project.totalTimeEstiamte > 0 ? 100 - Math.round(this.project.remainingTimeEstimate / this.project.totalTimeEstiamte * 100) : 0;
			}
		},
		methods: {
			updateProgressBar: function() {
				$('#' + this.progressBarId).progress({
					percent: this.completionPercent
				});
			},
			discardCreate: function(event) {
				this.$parent.deleteFromProjects(this.project.id)
			},
			createDateTimeString: function(dateTime) {
				return dateTime.toDateString() + ' at ' + dateTime.toLocaleTimeString();
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