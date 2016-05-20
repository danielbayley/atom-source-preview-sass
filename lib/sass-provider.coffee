sass = config = null

module.exports =
class SassProvider

	fromGrammarName: 'Sass'
	fromScopeName: 'source.sass'
	toScopeName: 'source.css'

	relative: ['.','..','../..']
#-------------------------------------------------------------------------------

	transform: (code, { filePath, sourceMap } = {}) ->
		# {renderSync} = sass ?= require 'node-sass'
		{execSync} = require 'child_process'
		{readFileSync} = require 'fs'
		{config: {includePaths}} = config ?= require '../package.json'

		indent = atom.workspace.getActiveTextEditor().getTabText()

		options =
			sourceMap: sourceMap
			outFile: 'preview.css'
			omitSourceMapUrl: true

			indentedSyntax: true
			outputStyle: 'expanded' #nested
			indentType: 'tab' if indent is '\t' #indent.charAt 0
			indentWidth: indent.length

			includePaths: includePaths.concat @relative, atom.project.getPaths()
			file: filePath
			data: code

		includes = options.includePaths.join "' -I '"

		preview = "/tmp/#{options.outFile}" #renderSync options

		sassc = "#{__dirname}/../sassc/bin/sassc"

		execSync """
			'#{sassc}' -mMt #{options.outputStyle} \
			-I '#{includes}' '#{filePath}' '#{preview}'
			"""
		code: readFileSync preview,'utf-8' #css.toString() #preview.css.toString()
		sourceMap: readFileSync "#{preview}.map",'utf-8' #preview.map?.toString()
