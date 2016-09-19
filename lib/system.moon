__dirname = (...)\match('(.-)[^%/%.]+$')
Caste = require('vendor/caste/lib/caste')
Criteria = require(__dirname .. 'criteria')

class System extends Caste

	@Criteria: Criteria
	@criteria: Criteria()

	active: false
	events: nil

	init: () =>
		@entities = {}
		if @onAdd then @events\on('system.entity.add', @onAdd, @)
		if @onRemove then @events\on('system.entity.remove', @onRemove, @)

	add: (...) =>
		entities = { ... }
		for entity in *entities
			table.insert(entity)
			if @events then @events\emit('system.entity.add', entity)

	remove: (...) =>
		entities = { ... }
		for entity in *entities
			for e = 1, #@entities
				ent = @entities[e]
				if ent == entity or ent.id == entity
					table.remove(@entities, e)
					if @events then @events\emit('system.entity.remove', ent)
					break

	get: (id) =>
		if not id then return @entities
		for e = 1, #@entities
			entity = @entities[e]
			if entity.id  == id then return entity

	has: (entity) =>
		entity = if type(entity) == 'table' then entity.id else entity
		return not not @get(entity)

	getCriteria: () => @@criteria

	sync: (...) =>
		entities = { ... }
		for entity in *entities
			matches = @@criteria\matches(entity)
			exists = @has(entity)
			if matches and not exists then @add(entity)
			if not matches and exists then @remove(entity)

	toggleActive: (...) =>
		isActive = super(...)
		if isActive and type(@onEnable) == 'function' then @onEnable()
		elseif not isActive and type(@onDisable) == 'function' then @onDisable()
		if type(@onToggle) == 'function' then @onToggle(isActive)
