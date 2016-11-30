{ :gsub, :split } = require('std.string')

export req = (path, file) ->
	pathParts = split(gsub(path, '/', '.'), '%.')
	firstFilePart = split(gsub(file, '/', '.'), '%.')[1]
	dir = ''
	for part in *pathParts
		if part == firstFilePart then break
		dir ..= "#{part}."
	require(dir .. file)

{
	Criteria: req(..., 'lib.criteria'),
	Entity: req(..., 'lib.entity'),
	EventEmitter: req(..., 'lib.event-emitter'),
	Secs: req(..., 'lib.secs'),
	System: req(..., 'lib.system'),
}
