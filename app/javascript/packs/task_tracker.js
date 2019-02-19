import appComponent from '../src/task_tracker/app.vue'

document.addEventListener("DOMContentLoaded", () => {
	var app = new Vue({
		el: '#app',
		components: {
			'App': appComponent
		},
		template: `<App></App>`
	});

});
