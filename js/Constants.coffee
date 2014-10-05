###*
 * This is a class (not actually but logically) that contains all definitions of constants.
 * Those constants can be con- or disjoined (see functions 'and' and 'or') but already con- or disjoined can't be con- or disjoined any further (so nesting is not supported).
 * @class CONSTANTS
*###
window.CONSTANTS =
	###########
	# FUNCTIONS
	and: (vals...) ->
		res = 0
		for val in vals
			res += val
		return res

	or: (vals...) ->
		res = 1
		for val in vals
			res += val
		return res

	###*
	 * This method gets the keys of a constant's object from a given value.
	 * @static
	 * @method get
	 * @param {Object} obj
	 * @param {Integer} val
	 * @return {Array} An array containing all keys of the according CONSTANTS object that are encoded in 'val'. The first index indicates if the keys are con- or disjoined (true means 'or', false means 'and')
	*###
	get: (obj, val) ->
		keys	= (key for key in Object.keys(obj) when key isnt "DEFAULT")
		n		= val
		idx		= 1 # skip LSB
		# true => OR, false => AND
		res		= [val % 2 is 1]
		n		= n >> 1

		while n > 0
			temp = Math.pow(2, idx)
			# if current binary digit is 1 => add to result, else => continue
			if n % 2 is 1
				for key in keys when obj[key] is temp
					res.push key
					# remove used key from key list
					keys = (k for k in keys when k isnt key)

			n = n >> 1 # = Math.floor(n / 2)
			idx++

		return res

	###*
	 * This method adds a new (!!) key to a given constant's object dynamically. If the key already exists an error is thrown.
	 * @static
	 * @method add
	 * @param {Object} obj
	 * @param {Integer} val
	 * @return {Array} An array containing all keys of the according CONSTANTS object that are encoded in 'val'. The first index indicates if the keys are con- or disjoined (true means 'or', false means 'and')
	*###
	add: (obj, key) ->
		maxVal = 0
		for k, v of obj
			if v > maxVal
				maxVal = v
			if k is key
				console.warn "Key '#{key}' already exists in", obj
				throw new Error("Key already exists!")

		obj[key] = maxVal * 2
		return @

	##################
	# ACTUAL CONSTANTS
	# PROGRESS_KINDS:
	# 	TIME:		2
	# 	VANISHED:	4 # die or finish
	# 	SPAWNED:	8



# set default values
# CONSTANTS.PROGRESS_KINDS.DEFAULT	= CONSTANTS.PROGRESS_KINDS.VANISHED
