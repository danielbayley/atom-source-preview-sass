sass = config = null

relative = ['.','..','../..']

module.exports =
class SassProvider
	fromGrammarName: 'Sass'
	fromScopeName: 'source.sass'
	toScopeName: 'source.css'

	transform: (code, { filePath, sourceMap } = {}) ->
		{renderSync} = sass ?= require 'node-sass'
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

			includePaths: includePaths.concat relative, atom.project.getPaths()
			file: filePath
			data: code

		preview = renderSync options
		{
			code: preview.css.toString()
			sourceMap: preview.map?.toString()
		}
