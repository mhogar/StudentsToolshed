import appComponent from '../src/app.vue'

document.addEventListener("DOMContentLoaded", () => {

	var app = new Vue({
		el: '#app',
		components: {
			'App': appComponent
		},
		template: `<App></App>`
	});

});
