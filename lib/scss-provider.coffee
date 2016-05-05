scss = config = null

module.exports =
class ScssProvider
	fromGrammarName: 'SCSS'
	fromScopeName: 'source.css.scss'
	toScopeName: 'source.css'

	relative: ['.','..','../..']
#-------------------------------------------------------------------------------

	transform: (code, { filePath, sourceMap } = {}) ->
		# {renderSync} = scss ?= require 'node-sass'
		# FIXME https://github.com/sass/node-sass/issues/1527
		# https://github.com/sass/node-sass/issues/1047
		# https://github.com/electron/electron/blob/master/docs/tutorial/using-native-node-modules.md
		# https://github.com/sass/node-sass-binaries
		# http://discuss.atom.io/t/cross-platform-sass-compilation-with-node-sass-libsass/26372/2
		{execSync} = require 'child_process' #exec
		{readFileSync} = require 'fs'
		{config: {includePaths}} = config ?= require '../package.json'

		indent = atom.workspace.getActiveTextEditor().getTabText()

		options =
			sourceMap: sourceMap
			outFile: 'preview.css'
			omitSourceMapUrl: true

			#indentedSyntax: false
			outputStyle: 'expanded'
			indentType: 'tab' if indent is '\t' #indent.charAt 0
			indentWidth: indent.length

			includePaths: includePaths.concat @relative, atom.project.getPaths()
			file: filePath
			data: code

		includes = options.includePaths.join "' -I '"

		preview = "/tmp/#{options.outFile}" #renderSync options

		execSync """
			*/*/bin/sassc -mMt #{options.outputStyle} \
			-I '#{includes}' '#{filePath}' #{preview}
			"""
		code: readFileSync preview,'utf-8' #css.toString() #preview.css.toString()
		sourceMap: readFileSync "#{preview}.map",'utf-8' #preview.map?.toString()
