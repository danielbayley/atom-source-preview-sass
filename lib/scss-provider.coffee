scss = config = null

module.exports =
class ScssProvider
	fromGrammarName: 'SCSS'
	fromScopeName: 'source.css.scss'
	toScopeName: 'source.css'

	transform: (code, {sourceMap} = {}) -> #filePath
		{renderSync} = scss ?= require 'node-sass'
		{config: { includePaths }} = config ?= require '../package.json'

		editor = atom.workspace.getActiveTextEditor()
		indent = editor.getTabText()

		options =
			sourceMap: true
			outFile: sourceMap
			#omitSourceMapUrl: true

			#indentedSyntax: false
			outputStyle: 'expanded'
			indentType: 'tab' if indent is '\t' #indent.charAt 0
			indentWidth: indent.length

			includePaths: includePaths.concat atom.project.getPaths()
			file: editor.getPath() #filePath
			data: code

		preview = renderSync options
		{
			code: preview.css.toString()
			sourceMap: preview.map ? null
		}
