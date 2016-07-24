Sass = require './sass-provider'
SCSS = require './scss-provider'

module.exports =
	activate: ->
		@sass = new Sass
		@scss = new SCSS

	deactivate: -> @sass = @scss = null

	provide: -> [ @sass, @scss ]
