Caste = require('vendor/caste/lib/caste')

class Entity extends Caste

	@count: 0

	events: nil

	new: (components) =>
		-- Assign pseudo-random id
		@id = (
			string.format('%x', os.time()) .. '|' ..
			string.format('%x', math.floor(math.random() * 100000000)) .. '|' ..
			@@count
		)
		@@count += 1
		@components = {}
		@addMultiple(components)

	init: () =>

	set: (key, component) =>
		unless component
			component = key
			key = component.type

		isNew = not @has(key)
		@components[key] = component
		-- TODO: Make getter, rather than duplicate
		@[key] = component

		if isNew and @events then @events\emit('entity.component.add', @, key)

	add: (key, component) =>
		unless component
			component = key
			key = component.type

		if @has(key) then error "Entity already has component '#{key}'."
		if @[key] then error "Entity already has property '#{key}'."

		@set(key, component)

	addMultiple: (components = {}) =>
		for key, component in pairs(components)
			if type(key) == 'number'
				@add(component)
			else
				@add(key, component)

	remove: (key) =>
		if not @has(key) then error "Tried removing nonexistent component '#{key}' from entity."

		@components[key] = nil
		@[key] = nil
		if @events then @events\emit('entity.component.remove', @, key)

	get: (key) => if key then @components[key] else @components
	has: (key) => not not @get(key)
