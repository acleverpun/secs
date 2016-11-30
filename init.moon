dots = (value) -> string.gsub(value, '/', '.')

split = (value, delimiter) ->
	result = {}
	fromIndex = 1
	delimFrom, delimTo = string.find(value, delimiter, fromIndex)
	while delimFrom
		table.insert(result, string.sub(value, fromIndex , delimFrom - 1))
		fromIndex = delimTo + 1
		delimFrom, delimTo = string.find(value, delimiter, fromIndex)
	table.insert(result, string.sub(value, fromIndex))
	return result

export req = (path, file) ->
	pathParts = split(dots(path), '%.')
	firstFilePart = split(dots(file), '%.')[1]
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
