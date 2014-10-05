# from js/init.coffee
###*
 * @module mathJS
 * @main mathJS
*###

window.mathJS = {}
# end js/init.coffee

# from js/globalFunctions.coffee
window.mixOf = (base, mixins...) ->
	class Mixed extends base

	# earlier mixins override later ones
	for mixin in mixins by -1
		for name, method of mixin.prototype
			Mixed::[name] = method

	return Mixed
# end js/globalFunctions.coffee

# from js/prototyping.coffee
#######################################################################
Array::reverseCopy = () ->
	res = []
	res.push(item) for item in @ by -1
	return res

Array::sample = (n = 1, forceArray = false) ->
	if n is 1
		if not forceArray
			return @[ Math.floor(Math.random() * @length) ]
		return [ @[ Math.floor(Math.random() * @length) ] ]

	if n > @length
		n = @length

	i = 0
	res = []
	arr = @clone()
	while i++ < n
		console.log arr
		elem = arr.sample(1)
		res.push elem
		arr.remove elem

	return res

Array::shuffle = () ->
	arr = @sample(@length)
	for elem, i in arr
		@[i] = elem
	return @

Array::first = () ->
	return @[0]

Array::last = () ->
	return @[@length - 1]

Array::average = () ->
	sum = 0
	elems = 0
	for elem in @ when Math.isNum(elem)
		sum += elem
		elems++

	return sum / elems

# make alias
Array::median = Array::average

Array::clone = Array::slice

Array::remove = (elem) ->
	idx = @indexOf elem
	if idx > -1
		@splice(idx, 1)
	return @

Array::removeAll = (elements = []) ->
	for elem in elements
		@remove elem
	return @

Array::removeAt = (idx) ->
	@splice(idx, 1)
	return @

###*
 * @method getMax
 * @param {Function} propertyGetter
 * The passed callback extracts the value being compared from the array elements.
 * @return {Array} An array of all maxima.
*###
Array::getMax = (propertyGetter) ->
	max = null
	res = []
	if not propertyGetter?
		propertyGetter = (item) ->
			return item

	for elem in @
		val = propertyGetter(elem)
		# new max found (or first compare) => restart list with new max value
		if val > max or max is null
			max = val
			res = [elem]
		# same as max found => add to list
		else if val is max
			res.push elem

	return res

Array::getMin = (propertyGetter) ->
	min = null
	res = []
	if not propertyGetter?
		propertyGetter = (item) ->
			return item

	for elem in @
		val = propertyGetter(elem)
		# new min found (or first compare) => restart list with new min value
		if val < min or min is null
			min = val
			res = [elem]
		# same as min found => add to list
		else if val is min
			res.push elem

	return res


#######################################################################
String::camel = (spaces) ->
	if not spaces?
		spaces = false

	str = @toLowerCase()
	if spaces
		str = str.split(" ")
		for i in [1...str.length]
			str[i] = str[i].charAt(0).toUpperCase() + str[i].substr(1)
		str = str.join("")

	return str

String::antiCamel = () ->
	res = @charAt(0)

	for i in [1...@length]
		temp = @charAt(i)
		# it's a capital letter -> insert space
		if temp is temp.toUpperCase()
			res += " "
		res += temp
	return res

String::firstToUpperCase = () ->
	return @charAt(0).toUpperCase() + @slice(1)

String::snakeToCamelCase = () ->
	res = ""

	for char in @
		# not underscore
		if char isnt "_"
			# previous character was not an underscore => just add character
			if prevChar isnt "_"
				res += char
			# previous character was an underscore => add upper case character
			else
				res += char.toUpperCase()

		prevChar = char

	return res

String::camelToSnakeCase = () ->
	res = ""
	prevChar = null
	for char in @
		# lower case => just add
		if char is char.toLowerCase()
			res += char
		# upper case
		else
			# previous character was lower case => add underscore and lower case character
			if prevChar is prevChar.toLowerCase()
				res += "_" + char.toLowerCase()
			# previous character was (also) upper case => just add
			else
				res += char

		prevChar = char

	return res
# end js/prototyping.coffee

# from js/mathJS.coffee
###*
 * This function checks if a given parameter is a (plain) number.
 * @method isNum
 * @param {Number} num
 * @return {Boolean} Whether the given number is a Number (excluding +/-Infinity)
*###
mathJS.isNum = (r) ->
    return (typeof r is "number") and not isNaN(r) and r isnt Infinity and r isnt -Infinity

###*
 * This function returns a random (plain) integer between max and min (both inclusive).
 * @method randInt
 * @param {Number} max
 * @param {Number} min
 * @return {Number} Random integer.
*###
mathJS.randInt = (max, min = 0) ->
    return Math.floor(Math.random() * (max + 1 - min)) + min

###*
 * This function returns a random number between max and min (both inclusive).
 * @method randNum
 * @param {Number} max
 * @param {Number} min
 * Default is 0.
 * @return {Integer} Random number.
*###
mathJS.randNum = (max, min = 0) ->
    return Math.random() * (max + 1 - min) + min

mathJS.radToDeg = (rad) ->
    return rad * 57.29577951308232 # = rad * (180 / Math.PI)

mathJS.degToRad = (deg) ->
    return deg * 0.017453292519943295 # = deg * (Math.PI / 180)

mathJS.sign = (n) ->
    if n?
        if n < 0
            return -1
        return 1
    return null
# end js/mathJS.coffee

# from js/Number.coffee
###*
 * @abstract
 * @class Number
 * @constructor
 * @param {Number} value
 * @extends Object
*###
class mathJS.Number
    ###########################################################################
    # STATIC
    @_pool = []

    @fromPool: (val) ->
        if @_pool.length > 0
            number = @_pool.pop()
            number.value = val
            return number
        else
            return new Number(val)

    @parse: (str) ->
        return @fromPool parseFloat(str)

    @getRandom: (max, min) ->
        return @fromPool mathJS.randNum(max, min)


    ###########################################################################
    # CONSTRUCTOR
    constructor: (value) ->
        if not @_valueIsValid(value)
            fStr = arguments.callee.caller.toString()
            throw new Error("mathJS: Expected plain number! Given #{value} at '#{fStr.substring(0, fStr.indexOf(")") + 1)}'")

        Object.defineProperty @, "value", {
            get: @_getValue.bind(@)
            set: @_setValue.bind(@, value)
        }

        @value = @_getValueFromParam(value)

    ###########################################################################
    # PRIVATE METHODS

    ###########################################################################
    # PROTECTED METHODS
    _setValue: (value) ->
        if @_valueIsValid(value)
            @_value = @_getValueFromParam(value)
        return @

    _getValue: () ->
        return @_value

    _valueIsValid: (value) ->
        return value? and (value instanceof @constructor or mathJS.isNum(value))

    ###*
    * This method gets the value from a <b>valid</b> parameter. The validity is determined by this._valueIsValid().
    * @method _getValueFromParam
    * @param {Number} param
    *
    *###
    _getValueFromParam: (param) ->
        if param instanceof mathJS.Number
            value = param.value
        else if mathJS.isNum param
            value = param

        return value


    ###########################################################################
    # PUBLIC METHODS
    # getValue: () ->
    #     return @_value

    plus: (n) ->
        return @constructor.fromPool(@value + n)

    increase: (n) ->
        @value += n
        return @

    minus: (n) ->
        return @constructor.fromPool(@value - n)

    decrease: (n) ->
        @value -= n
        return @

    times: (n) ->
        return @constructor.fromPool(@value * n)

    clone: () ->
        return @constructor.fromPool(@value)

    divide: (n) ->
        return @constructor.fromPool(@value / n)

    sign: () ->
        return mathJS.sign @value

    # add instance to pool
    release: () ->
        @constructor._pool.push @
        return @constructor
# end js/Number.coffee

# from js/Double.coffee
class mathJS.Double extends mathJS.Number

    constructor: (value) ->
        super
# end js/Double.coffee

# from js/Int.coffee
class mathJS.Int extends mathJS.Number

    constructor: (value) ->
        # if value instanceof mathJS.Int
        #     super value.value
        # else if
# end js/Int.coffee

# from js/Fraction.coffee
class mathJS.Fraction extends mathJS.Number

    constructor: (enumerator, denominator) ->
        @enumerator = enumerator
        @denominator = denominator
        Object.defineProperty @, "value", {
            # writable: false
            get: () ->
                return @enumerator / @denominator
        }
# end js/Fraction.coffee

# from js/Set.coffee
class mathJS.Set

    constructor: () ->
        # body...

    add: () ->

    remove: () ->

    union: () ->

    intersect: () ->

    complement: () ->

    ###*
    * a.without b => returns: removed all common elements from a
    *###
    without: () ->
# end js/Set.coffee

# from js/SpecificSet.coffee
class mathJS.SpecificSet extends mathJS.Set

    constructor: (args) ->
        # body...
# end js/SpecificSet.coffee

# from js/ConditionalSet.coffee
class mathJS.ConditionalSet extends mathJS.Set

    constructor: (args) ->
        # body...
# end js/ConditionalSet.coffee

# from js/Function.coffee
class mathJS.Function extends mathJS.ConditionalSet

    constructor: (fromSet, toSet, mapping) ->
        @fromSet = fromSet
        @toSet = toSet
        @mapping = mapping
# end js/Function.coffee

# from js/start.coffee
$(document).ready () ->
	# window.g = new TD.Game()
	console.log "dom ready"
# end js/start.coffee

