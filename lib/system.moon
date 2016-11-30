Caste = require('vendor/caste/lib/caste')
Criteria = req(..., 'lib.criteria')

class System extends Caste

	@Criteria: Criteria
	@criteria: Criteria()

	active: true

	init: () => @entities = {}

	add: (...) =>
		entities = { ... }
		for entity in *entities
			table.insert(@entities, entity)
			if @onAdd then @onAdd(entity)
		return @

	remove: (...) =>
		entities = { ... }
		for entity in *entities
			for e = 1, #@entities
				ent = @entities[e]
				if ent == entity or ent.id == entity
					table.remove(@entities, e)
					if @onRemove then @onRemove(ent)
					break
		return @

	get: (id) =>
		if not id then return @entities
		for e = 1, #@entities
			entity = @entities[e]
			if entity.id  == id then return entity

	has: (...) =>
		entities = { ... }
		for entity in *entities
			entity = if type(entity) == 'table' then entity.id else entity
			if not @get(entity) then return false
		return true

	getCriteria: () => @@criteria

	sync: (...) =>
		entities = { ... }
		for entity in *entities
			matches = @@criteria\matches(entity)
			exists = @has(entity)
			if matches and not exists then @add(entity)
			if not matches and exists then @remove(entity)
		return @

	start: () => @toggle(true)
	stop: () => @toggle(false)
	toggle: (active) =>
		active = if active != nil then active else not @active
		@active = active
		if active and type(@onStart) == 'function' then @onStart()
		elseif not active and type(@onStop) == 'function' then @onStop()
		if type(@onToggle) == 'function' then @onToggle(active)
		return @
