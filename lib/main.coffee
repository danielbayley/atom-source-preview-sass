SassProvider = require './sass-provider'
ScssProvider = require './scss-provider'

module.exports =

	activate: ->
		@sassProvider = new SassProvider
		@scssProvider = new ScssProvider

	deactivate: -> @sassProvider = @scssProvider = null

	provide: -> [@sassProvider, @scssProvider]
