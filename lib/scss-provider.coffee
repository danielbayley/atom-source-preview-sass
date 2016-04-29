scss = config = null

relative = ['.','..','../..']

module.exports =
class ScssProvider
	fromGrammarName: 'SCSS'
	fromScopeName: 'source.css.scss'
	toScopeName: 'source.css'

	transform: (code, { filePath, sourceMap } = {}) ->
		{renderSync} = scss ?= require 'node-sass'
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

			includePaths: includePaths.concat relative, atom.project.getPaths()
			file: filePath
			data: code

		preview = renderSync options
		{
			code: preview.css.toString()
			sourceMap: preview.map?.toString()
		}
