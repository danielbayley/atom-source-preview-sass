sass = config = null

module.exports =
class SassProvider
	fromGrammarName: 'Sass'
	fromScopeName: 'source.sass'
	toScopeName: 'source.css'

	transform: (code, {sourceMap} = {}) -> #filePath
		{renderSync} = sass ?= require 'node-sass'
		{config: { includePaths }} = config ?= require '../package.json'

		editor = atom.workspace.getActiveTextEditor()
		indent = editor.getTabText()

		options =
			sourceMap: true
			outFile: sourceMap
			#omitSourceMapUrl: true

			indentedSyntax: true
			outputStyle: 'expanded' #nested
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
