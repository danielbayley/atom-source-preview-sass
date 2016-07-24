module.exports =
class SCSS

	fromGrammarName: 'SCSS'
	fromScopeName: 'source.css.scss'
	toScopeName: 'source.css'

	include: ['.','..','../..','lib','styles','sass','scss','css']
		#'assets/styles'
		#'assets/sass'
		#'assets/scss'
		#'assets/css'
		#'partials'
		#'mixins'
		#'modules'
		#'helpers'
	#]
#-------------------------------------------------------------------------------

	transform: (code, { filePath, sourceMap }) ->
		# {renderSync} = require 'node-sass'
		# FIXME https://github.com/sass/node-sass/issues/1527
		# https://github.com/sass/node-sass/issues/1047
		# https://github.com/electron/electron/blob/master/docs/tutorial/using-native-node-modules.md
		# https://github.com/sass/node-sass-binaries
		# http://discuss.atom.io/t/cross-platform-sass-compilation-with-node-sass-libsass/26372/2
		{execSync} = require 'child_process' #exec
		{readFileSync} = require 'fs'

		indent = atom.workspace.getActiveTextEditor().getTabText()

		options =
			sourceMap: sourceMap
			outFile: 'preview.css'
			omitSourceMapUrl: true

			#indentedSyntax: false
			outputStyle: 'expanded'
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
