window.mixOf = (base, mixins...) ->
	class Mixed extends base

	# earlier mixins override later ones
	for mixin in mixins by -1
		for name, method of mixin.prototype
			Mixed::[name] = method

	return Mixed
