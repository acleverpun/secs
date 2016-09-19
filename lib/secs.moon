__dirname = (...)\match('(.-)[^%/%.]+$')
Caste = require('vendor/caste/lib/caste')
EventEmitter = require(__dirname .. 'event-emitter')

class Secs extends Caste

	new: () =>
		@events = EventEmitter()
		@entities = {}
		@systems = {}

		@events\on('entity.component.add', @updateComponent, @)
		@events\on('entity.component.remove', @updateComponent, @)

	addSystem: (system) =>
		system.active = true
		system.events = @events
		@systems[system\getCriteria()] = system

		for entity in *@entities
			if system\matches(entity) then system\add(entity)

		system\init()

	removeSystem: (system) =>
		system.events = nil
		@systems[system\getCriteria()] = nil

	getSystem: (system) => return @systems[system] or @systems[system\getCriteria()]
	startSystem: (system) => @toggleSystem(system, true)
	stopSystem: (system) => @toggleSystem(system, false)
	toggleSystem: (system, active) =>
		system = @getSystem(system)
		system.active = if active == nil then not system.active else active

	addEntity: (entity) =>
		entity.events = @events
		table.insert(@entities, entity)
		@events\emit('secs.entity.add', entity)

		for criteria, system in pairs(@systems)
			if criteria\matches(entity) then system\add(entity)

		entity\init()

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

	-- Sync entities/systems as components change
	updateComponent: (entity, component) =>
		for criteria, system in pairs(@systems)
			if criteria\involves(component) then system\sync(entity)

	update: (dt) =>
		for criteria, system in pairs(@systems)
			if not system.update or not system.active then continue
			system\update(dt)

	draw: () =>
		for criteria, system in pairs(@systems)
			if not system.draw or not system.active then continue
			system\draw()
