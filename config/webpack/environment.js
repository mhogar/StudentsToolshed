const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const customConfig = require('./custom')
const VueLoaderPlugin = require('vue-loader/lib/plugin');

environment.config.merge(customConfig)

environment.loaders.append('vue', {
	test: /\.vue$/,
	loader: 'vue-loader'
});

environment.loaders.append('css', {
	test: /\.css$/,
    use: [
  		'vue-style-loader',
      	'css-loader'
    ]
});

environment.plugins.prepend(
	'Provide', 
	new webpack.ProvidePlugin({
		$: 'jquery',
		jQuery: 'jquery',
		jquery: 'jquery',
		Vue: 'vue'
	})
);

environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin());

module.exports = environment
