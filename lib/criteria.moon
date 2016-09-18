Caste = require('vendor/caste/lib/caste')

includes = (array, value) ->
	for item in *array
		if item == value then return true
	return false

class Criteria extends Caste

	new: (@all = {}, @any = {}, @none = {}) =>

	-- Returns whether the criteria matches the given entity
	matches: (entity) =>
		for component in *@all
			if not entity\has(component) then return false
		for component in *@none
			if entity\has(component) then return false
		hasAny = false
		for component in *@any
			if entity\has(component) then return true
			hasAny = true
		return not hasAny

	-- Returns whether the criteria involves the given component
	involves: (component) =>
		return includes(@all, component) or includes(@any, component) or includes(@none, component)
