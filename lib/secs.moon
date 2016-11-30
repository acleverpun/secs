Caste = require('vendor/caste/lib/caste')
EventEmitter = req(..., 'lib.event-emitter')

class Secs extends Caste

	new: () =>
		@events = EventEmitter()
		@entities = {}
		@systems = {}

		@events\on('entity.component.add', @updateComponent, @)
		@events\on('entity.component.remove', @updateComponent, @)

	addSystem: (system) =>
		@systems[system\getCriteria()] = system
		if system.active then @startSystem(system)

		for entity in *@entities
			if system\matches(entity) then system\add(entity)

		system\init()
		return @

	removeSystem: (system) =>
		@stopSystem(system)
		@systems[system\getCriteria()] = nil
		return @

	getSystem: (system) => return @systems[system] or @systems[system\getCriteria()]

	startSystem: (system) =>
		@toggleSystem(system, true)
		return @
	stopSystem: (system) =>
		@toggleSystem(system, false)
		return @
	toggleSystem: (system, active) =>
		@getSystem(system)\toggle(active)
		return @

	addEntity: (entity) =>
		entity.events = @events
		table.insert(@entities, entity)
		@events\emit('secs.entity.add', entity)

		for criteria, system in pairs(@systems)
			if criteria\matches(entity) then system\add(entity)

		entity\init()
		return @

	removeEntity: (entity) =>
		for e = 1, #@entities
			ent = @entities[e]
			if ent == entity or ent.id == entity
				ent.events = nil
				table.remove(@entities, e)
				@events\emit('secs.entity.remove', ent)
				break

		for criteria, system in pairs(@systems)
			if system\has(entity) then system\remove(entity)

		return @

	-- Sync entities/systems as components change
	updateComponent: (entity, component) =>
		for criteria, system in pairs(@systems)
			if criteria\involves(component) then system\sync(entity)
		return @

	update: (dt) =>
		for criteria, system in pairs(@systems)
			if not system.update or not system.active then continue
			system\update(dt)

	draw: () =>
		for criteria, system in pairs(@systems)
			if not system.draw or not system.active then continue
			system\draw()
