Caste = require('vendor/caste/lib/caste')
Criteria = require('lib/criteria')

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
			if not entity.id then error 'Added entity has no id.'
			if @entities[entity.id] then error 'Entity already present.'
			@entities[entity.id] = entity
			if @events then @events\emit('system.entity.add', entity)

	remove: (...) =>
		entities = { ... }
		for entity in *entities
			if not entity.id then error 'Added entity has no id.'
			if not @entities[entity.id] then error 'Entity not present.'
			@entities[entity.id] = nil
			if @events then @events\emit('system.entity.remove', entity)

	get: (entity) => if entity then @entities[entity] or @entities[entity.id] else @entities
	has: (entity) => not not @get(entity)
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
