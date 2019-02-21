const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const VueLoaderPlugin = require('vue-loader/lib/plugin');

environment.config.merge({
  	resolve: {
    	alias: {
      		vue: 'vue/dist/vue.js'
    	}
  	}
});

environment.loaders.append('vue', {
	test: /\.vue$/,
	use: [
		'vue-loader'
	]
});

environment.loaders.append('css', {
	test: /\.css$/,
    use: [
  		'vue-style-loader',
      	'css-loader',
    ]
});

environment.plugins.prepend(
	'Provide', 
	new webpack.ProvidePlugin({
		Vue: 'vue'
	})
);

environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin());

module.exports = environment
