module.exports =
class Sass

	fromGrammarName: 'Sass'
	fromScopeName: 'source.sass'
	toScopeName: 'source.css'

	include: ['.','..','../..','lib','styles','sass','css']
		#'assets/styles'
		#'assets/sass'
		#'assets/css'
		#'partials'
		#'mixins'
		#'modules'
		#'helpers'
	#]
#-------------------------------------------------------------------------------

	transform: (code, { filePath, sourceMap }) ->
		# {renderSync} = require 'node-sass'
		{execSync} = require 'child_process'
		{readFileSync} = require 'fs'

		indent = atom.workspace.getActiveTextEditor().getTabText()

		options =
			sourceMap: sourceMap
			outFile: 'preview.css'
			omitSourceMapUrl: true

			indentedSyntax: true
			outputStyle: 'expanded' #nested
			indentType: 'tab' if indent is '\t' #indent.charAt 0
			indentWidth: indent.length

			include: @include.concat atom.project.getPaths()
			file: filePath
			data: code

		include = options.include.join "' -I '"

		preview = "/tmp/#{options.outFile}" #renderSync options

		sassc = "#{__dirname}/../sassc/bin/sassc"

		execSync """
			'#{sassc}' -mMt #{options.outputStyle} \
			-I '#{include}' '#{filePath}' '#{preview}'
			"""
		code: readFileSync preview,'utf-8' #css.toString() #preview.css.toString()
		sourceMap: readFileSync "#{preview}.map",'utf-8' #preview.map?.toString()
