<template>
	<form class="ui form" v-on:submit.prevent="!discarded && onSave($event)">
		<div class="ui input fluid action">
			<input type="text" name="name" v-model="model.name" v-bind:id="inputId" />
			<button class="ui button blue" type="submit">Save</button>
			<button class="ui button" v-on:click="discarded = true; discardFunc($event)">Discard</button>
		</div>
	</form>
</template>

<script>
	export default {
		props: ['saveFunc', 'discardFunc', 'model', 'id_name', 'validations'],
		data: function() {
			return {
				discarded: false
			};
		},
		computed: {
			inputId: function() {
				return this.id_name + this.model.id;
			}
		},
		methods: {
			createPopup: function(content) {
				$('#' + this.inputId).popup({
					content: content,
					on: 'manual'
				});
			},
			validateInput: function() {
				if (!validations.required && field === '') {
					return true;
				}

				if (this.validations.required && this.model.name === '') {
					this.createPopup('This field is required.');
					$('#' + this.inputId).popup('show');
					return false;
				}

				if (this.model.name.length < this.validations.minLength) {
					this.createPopup('Min length: ' + this.validations.minLength);
					$('#' + this.inputId).popup('show');
					return false;
				}

				if (this.model.name.length > this.validations.maxLength) {
					this.createPopup('Max length: ' + this.validations.maxLength);
					$('#' + this.inputId).popup('show');
					return false;
				}

				return true;
			},
			onSave: function(event) {
				if (this.validateInput()) {
					this.saveFunc(event);
				}
			}
		},
		mounted: function() {
			document.getElementById(this.inputId).focus();

			console.log(this.validations);
		}
	};
</script>
