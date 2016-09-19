Caste = require('vendor/caste/lib/caste')

class EventEmitter extends Caste

	new: () =>
		@listeners = {}

	on: (event, listener, this) =>
		if not @listeners[event] then @listeners[event] = {}
		table.insert(@listeners[event], { listener, this })

	once: (event, listener, this) => @many(event, 1, listener, this)
	many: (event, ttl, listener, this) =>
		wrapper = (...) =>
			ttl -= 1
			if ttl == 0 then @off(event, wrapper)
			listener(...)
		@on(event, wrapper, this)

	emit: (event, ...) =>
		event = @listeners[event]
		if not event then return
		for { listener, this } in *event
			if this then listener(this, ...) else listener(...)

	off: (event, listener) =>
	removeListener: (...) => @off(...)
	removeAllListeners: (event) =>

	eventNames: () =>
		names = {}
		for name, listener in pairs(@listeners)
			table.insert(names, name)
		return names
