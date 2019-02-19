<template>
	<form class="ui form" v-on:submit.prevent="onSave($event)">
		<div class="fields">
			<div class="four wide field">
				<label>Name</label>
				<input id="project-name-input" type="text" name="name" placeholder="Name (required)" v-model="model.name" />
			</div>
			<div class="ten wide field">
				<label>Description</label>
				<input id="project-description-input" type="text" name="description" placeholder="Add a description" v-model="model.description" />
			</div>
		</div>
		<button class="ui button blue" type="submit">Save</button>
		<button class="ui button" v-on:click="discardFunc($event)">Discard</button>
  	</form>
</template>

<script>
	export default {
		props: ['saveFunc', 'discardFunc', 'model'],
		data: function() {
			return {
				nameValidations: {
					required: true,
					minLength: 1,
					maxLength: 20
				},
				descValidations: {
					required: false,
					minLength: 10,
					maxLength: 100
				}
			};
		},
		methods: {
			createPopup: function(id, content) {
				$('#' + id).popup({
					content: content,
					on: 'manual'
				});
			},
			validateField: function(popupId, field, validations) {
				if (!validations.required && field === '') {
					return true;
				}

				if (validations.required && field === '') {
					this.createPopup(popupId, 'This field is required.');
					$('#' + popupId).popup('show');
					return false;
				}

				if (field.length < validations.minLength) {
					this.createPopup(popupId, 'Min length: ' + validations.minLength);
					$('#' + popupId).popup('show');
					return false;
				}
				
				if (field.length > validations.maxLength) {
					this.createPopup(popupId, 'Max length: ' + validations.maxLength);
					$('#' + popupId).popup('show');
					return false;
				}

				return true;
			},
			onSave: function(event) {
				if (this.validateField('project-name-input', this.model.name, this.nameValidations) && this.validateField('project-description-input', this.model.description, this.descValidations)) {
					this.saveFunc(event);
				}
			}
		},
		mounted: function() {
			document.getElementById('project-name-input').focus();
		}
	};
</script>
