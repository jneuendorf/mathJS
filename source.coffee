# from js/init.coffee
###*
 * @module mathJS
 * @main mathJS
*###

if typeof DEBUG is "undefined"
    window.DEBUG = true

window.mathJS = {}
# end js/init.coffee

# from js/globalFunctions.coffee
window.mixOf = (base, mixins...) ->
	class Mixed extends base

	# earlier mixins override later ones
	for mixin in mixins by -1
		# static
		for name, method of mixin
			Mixed[name] = method
		# non-static
		for name, method of mixin.prototype
			Mixed::[name] = method


	# attach 'instanceof' equivalent method
	superClasses = Array::slice.call(arguments, 0)
	Mixed::instanceof = (cls) ->
		# real inheritance => normal check
		if @ instanceof cls
			return true
		# check mixed in classes
		for c in superClasses when c is cls
				return true

		return false

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
#################################################################################################
# THIS FILE CONTAINS ALL PROPERITES AND FUNCTIONS THAT ARE BOUND DIRECTLY TO mathJS

# CONSTRANTS
Object.defineProperties mathJS, {
    e:
        value: Math.E
        writable: false
    pi:
        value: Math.PI
        writable: false
    ln2:
        value: Math.LN2
        writable: false
    ln10:
        value: Math.LN10
        writable: false
    log2e:
        value: Math.LOG2E
        writable: false
    log10e:
        value: Math.LOG10E
        writable: false
    # This value behaves slightly differently than mathematical infinity:
    #
    # Any positive value, including POSITIVE_INFINITY, multiplied by NEGATIVE_INFINITY is NEGATIVE_INFINITY.
    # Any negative value, including NEGATIVE_INFINITY, multiplied by NEGATIVE_INFINITY is POSITIVE_INFINITY.
    # Zero multiplied by NEGATIVE_INFINITY is NaN.
    # NaN multiplied by NEGATIVE_INFINITY is NaN.
    # NEGATIVE_INFINITY, divided by any negative value except NEGATIVE_INFINITY, is POSITIVE_INFINITY.
    # NEGATIVE_INFINITY, divided by any positive value except POSITIVE_INFINITY, is NEGATIVE_INFINITY.
    # NEGATIVE_INFINITY, divided by either NEGATIVE_INFINITY or POSITIVE_INFINITY, is NaN.
    # Any number divided by NEGATIVE_INFINITY is Zero.
    infty:
        value: Infinity
        writable: false
    infinity:
        value: Infinity
        writable: false
    epsilon:
        value: Number.EPSILON
        writable: false
    maxValue:
        value: Number.MAX_VALUE
        writable: false
    minValue:
        value: Number.MIN_VALUE
        writable: false

    # number sets / systems
    # N:
    #     value: new mathJS.Set()
    #     writable: false
}

mathJS.isPrimitive = (x) ->
    return typeof x is "string" or typeof x is "number" or typeof x is "boolean"

mathJS.isComparable = (x) ->
    return x instanceof mathJS.Comparable or x.instanceof?(mathJS.Comparable) or mathJS.isPrimitive x


mathJS.ceil = Math.ceil

# faster way of rounding down
mathJS.floor = (n) ->
    # if mathJS.isNum(n)
    #     return ~~n
    # return NaN
    return ~~n

mathJS.floatToInt = mathJS.floor

mathJS.square = (n) ->
    if mathJS.isNum(n)
        return n * n
    return NaN

mathJS.cube = (n) ->
    if mathJS.isNum(n)
        return n * n * n
    return NaN


# TODO: jsperf
mathJS.pow = Math.pow

# TODO: jsperf
mathJS.sqrt = Math.sqrt

mathJS.curt = (n) ->
    if mathJS.isNum(n)
        return mathJS.pow(n, 1 / 3)
    return NaN

mathJS.root = (n, exp) ->
    if mathJS.isNum(n) and mathJS.isNum(exp)
        return mathJS.pow(n, 1 / exp)
    return NaN


mathJS.parseNumber = (str) ->
    # TODO
    return null

###*
 * This function checks if a given parameter is a (plain) number.
 * @method isNum
 * @param {Number} num
 * @return {Boolean} Whether the given number is a Number (excluding +/-Infinity)
*###
# mathJS.isNum = (r) ->
    # return (typeof r is "number") and not isNaN(r) and r isnt Infinity and r isnt -Infinity
    # return not isNaN(r) and -Infinity < r < Infinity
mathJS.isNum = (n) ->
    return n? and isFinite(n)

mathJS.isInt = (r) ->
    return mathJS.isNum(r) and mathJS.floor(r) is r

###*
 * This function returns a random (plain) integer between max and min (both inclusive). If max is less than min the parameters are swapped.
 * @method randInt
 * @param {Number} max
 * @param {Number} min
 * @return {Number} Random integer.
*###
mathJS.randInt = (max = 1, min = 0) ->
    if min > max
        temp = min
        min = max
        max = temp
    return Math.floor(Math.random() * (max + 1 - min)) + min

###*
 * This function returns a random number between max and min (both inclusive). If max is less than min the parameters are swapped.
 * @method randNum
 * @param {Number} max
 * @param {Number} min
 * Default is 0.
 * @return {Integer} Random number.
*###
mathJS.randNum = (max = 1, min = 0) ->
    if min > max
        temp = min
        min = max
        max = temp
    return Math.random() * (max + 1 - min) + min

mathJS.radToDeg = (rad) ->
    return rad * 57.29577951308232 # = rad * (180 / Math.PI)

mathJS.degToRad = (deg) ->
    return deg * 0.017453292519943295 # = deg * (Math.PI / 180)

mathJS.sign = (n) ->
    if mathJS.isNum(n)
        if n < 0
            return -1
        return 1
    return NaN

mathJS.log = (n, base = 10) ->
    return Math.log(n) / Math.log(base)

mathJS.logBase = mathJS.log

mathJS.reciprocal = (n) ->
    if mathJS.isNum(n)
        return 1 / n
    return NaN
# end js/mathJS.coffee

# from js/interfaces/Comparable.coffee
class mathJS.Comparable

    ###*
    * This method checks for mathmatical equality. This means new mathJS.Double(4.2).equals(4.2) is true.
    * @method equals
    * @param {Number} n
    * @return {Boolean}
    *###
    equals: (n) ->
        throw new Error("To be implemented!")

    e: @::equals
# end js/interfaces/Comparable.coffee

# from js/interfaces/Orderable.coffee
class mathJS.Orderable extends mathJS.Comparable

    ###*
    * This method checks for mathmatical '<'. This means new mathJS.Double(4.2).lessThan(5.2) is true.
    * @method lessThan
    * @param {Number} n
    * @return {Boolean}
    *###
    lessThan: (n) ->
        throw new Error("To be implemented!")

    ###*
    * Alias for `lessThan`.
    * @method lt
    *###
    lt: @::lessThan

    ###*
    * This method checks for mathmatical '>'. This means new mathJS.Double(4.2).greaterThan(3.2) is true.
    * @method greaterThan
    * @param {Number} n
    * @return {Boolean}
    *###
    greaterThan: (n) ->
        throw new Error("To be implemented!")

    ###*
    * Alias for `greaterThan`.
    * @method lt
    *###
    gt: @::greaterThan

    ###*
    * This method checks for mathmatical '<='. This means new mathJS.Double(4.2).lessThanOrEqualTo(5.2) is true.
    * @method lessThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *###
    lessThanOrEqualTo: (n) ->
        throw new Error("To be implemented!")

    ###*
    * Alias for `lessThanOrEqualTo`.
    * @method lt
    *###
    lte: @::lessThanOrEqualTo

    ###*
    * This method checks for mathmatical '>='. This means new mathJS.Double(4.2).greaterThanOrEqualTo(3.2) is true.
    * @method greaterThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *###
    greaterThanOrEqualTo: (n) ->
        throw new Error("To be implemented!")

    ###*
    * Alias for `greaterThanOrEqualTo`.
    * @method lt
    *###
    gte: @::greaterThanOrEqualTo
# end js/interfaces/Orderable.coffee

# from js/interfaces/Parseable.coffee
class mathJS.Parseable

    @parse: (str) ->
        throw new Error("To be implemented")

    toString: (args) ->
        throw new Error("To be implemented")
# end js/interfaces/Parseable.coffee

# from js/interfaces/Poolable.coffee
class mathJS.Poolable

    @_pool = []

    @fromPool: () ->
        # implementation should be something like:
        # if @_pool.length > 0
        #     return @_pool.pop()
        # return new @()
        throw new Error("To be implemented")

    @new: () ->
        if arguments.length > 0
            return @fromPool.apply(@, arguments)
        return @fromPool()

    # release instance to pool
    release: () ->
        @constructor._pool.push @
        return @constructor
# end js/interfaces/Poolable.coffee

# from js/Numbers/Number.coffee
###*
 * @abstract
 * @class Number
 * @constructor
 * @param {Number} value
 * @extends Object
*###
class mathJS.Number extends mixOf mathJS.Orderable, mathJS.Poolable, mathJS.Parseable
    ###########################################################################################
    # STATIC
    @_valueIsValid: (value) ->
        return value instanceof mathJS.Number or mathJS.isNum(value)

    ###*
    * This method gets the value from a parameter. The validity is determined by this._valueIsValid().
    * @static
    * @protected
    * @method _getValueFromParam
    * @param {Number} param
    * @param {Boolean} skipCheck
    * If `true` the given parameter is not (again) checked for validity. If the function that calls _getValueFromParam() has already checked the passed parameter this `skipCheck` should be set to true.
    * @return {Number} The primitive value or null.
    *###
    @_getValueFromParam: (param, skipCheck) ->
        if not skipCheck and not @_valueIsValid(param)
            return null

        if param instanceof mathJS.Number
            value = param.value
        else if mathJS.isNum param
            value = param

        return value


    ###*
    * @Override mathJS.Poolable
    * @static
    * @method fromPool
    *###
    @fromPool: (val) ->
        if @_pool.length > 0
            if @_valueIsValid val
                number = @_pool.pop()
                number.value = val
                return number
            return null
        else
            return new @(val) # param check is done in constructor

    ###*
    * @Override mathJS.Parseable
    * @static
    * @method parse
    *###
    @parse: (str) ->
        if mathJS.isNum(parsed = parseFloat(str))
            return @fromPool parsed
        return parsed

    @random: (max, min) ->
        return @fromPool mathJS.randNum(max, min)


    ###########################################################################
    # CONSTRUCTOR
    constructor: (value) ->
        if not @_valueIsValid(value)
            fStr = arguments.callee.caller.toString()
            throw new Error("mathJS: Expected plain number! Given #{value} in '#{fStr.substring(0, fStr.indexOf(")") + 1)}'")

        Object.defineProperties @, {
            value:
                get: @_getValue
                set: @_setValue
            fromPool:
                value: @constructor.fromPool.bind(@constructor)
                writable: false
                enumarable: false
                configurable: false
        }

        @value = @_getValueFromParam(value, true)

    ###########################################################################
    # PRIVATE METHODS

    ###########################################################################
    # PROTECTED METHODS
    _setValue: (value) ->
        if @_valueIsValid(value)
            @_value = @_getValueFromParam(value, true)
        return @

    _getValue: () ->
        return @_value

    # link to static methods
    _valueIsValid: @_valueIsValid

    _getValueFromParam: @_getValueFromParam


    ###########################################################################
    # PUBLIC METHODS

    # IMPLEMENTING COMPARABLE
    ###*
    * @Override mathJS.Comparable
    * This method checks for mathmatical equality. This means new mathJS.Double(4.2).equals(4.2) is true.
    * @method equals
    * @param {Number} n
    * @return {Boolean}
    *###
    equals: (n) ->
        return @value is @_getValueFromParam(n)

    ###*
    * @Override mathJS.Orderable
    * This method check for mathmatical '<'. This means new mathJS.Double(4.2).lessThan(5.2) is true.
    * @method lessThan
    *###
    lessThan: (n) ->
        return @value < @_getValueFromParam(n)

    ###*
    * @Override mathJS.Orderable
    * This method check for mathmatical '>'. This means new mathJS.Double(4.2).greaterThan(3.2) is true.
    * @method greaterThan
    * @param {Number} n
    * @return {Boolean}
    *###
    greaterThan: (n) ->
        return @value > @_getValueFromParam(n)

    ###*
    * @Override mathJS.Orderable
    * This method check for mathmatical equality. This means new mathJS.Double(4.2).lessThanOrEqualTo(3.2) is true.
    * @method lessThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *###
    lessThanOrEqualTo: (n) ->
        return @value <= @_getValueFromParam(n)

    ###*
    * This method check for mathmatical equality. This means new mathJS.Double(4.2).lessThanOrEqualTo(3.2) is true.
    * @method greaterThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *###
    greaterThanOrEqualTo: (n) ->
        return @value >= @_getValueFromParam(n)


    # END - IMPLEMENTING COMPARABLE


    ###*
    * This method adds 2 numbers and returns a new one.
    * @method plus
    * @param {Number} n
    * @return {Number} Calculated Number.
    *###
    plus: (n) ->
        return @fromPool(@value + @_getValueFromParam(n))

    ###*
    * This method adds the given number to this instance.
    * @method increase
    * @param {Number} n
    * @return {Number} This instance.
    *###
    increase: (n) ->
        @value += @_getValueFromParam(n)
        return @

    ###*
    * See increase().
    * @method plusSelf
    *###
    plusSelf: @increase

    ###*
    * This method substracts 2 numbers and returns a new one.
    * @method minus
    * @param {Number} n
    * @return {Number} Calculated Number.
    *###
    minus: (n) ->
        return @fromPool(@value - n)

    decrease: (n) ->
        @value -= @_getValueFromParam(n)
        return @

    minusSelf: @decrease

    ###*
    * This method multiplies 2 numbers and returns a new one.
    * @method times
    * @param {Number} n
    * @return {Number} Calculated Number.
    *###
    times: (n) ->
        return @fromPool(@value * @_getValueFromParam(n))

    timesSelf: (n) ->
        @value *= @_getValueFromParam(n)
        return @

    ###*
    * This method divides 2 numbers and returns a new one.
    * @method divide
    * @param {Number} n
    * @return {Number} Calculated Number.
    *###
    divide: (n) ->
        return @fromPool(@value / @_getValueFromParam(n))

    divideSelf: (n) ->
        @value /= @_getValueFromParam(n)
        return @

    ###*
    * This method squares this instance and returns a new one.
    * @method square
    * @return {Number} Calculated Number.
    *###
    square: () ->
        return @fromPool(@value * @value)

    squareSelf: () ->
        @value *= @value
        return @

    ###*
    * This method cubes this instance and returns a new one.
    * @method cube
    * @return {Number} Calculated Number.
    *###
    cube: () ->
        return @fromPool(@value * @value * @value)

    cubeSelf: () ->
        @value *= @value * @value
        return @

    ###*
    * This method calculates the square root of this instance and returns a new one.
    * @method sqrt
    * @return {Number} Calculated Number.
    *###
    sqrt: () ->
        return @fromPool mathJS.sqrt(@value)

    sqrtSelf: () ->
        @value = mathJS.sqrt @value
        return @

    ###*
    * This method calculates the cubic root of this instance and returns a new one.
    * @method curt
    * @return {Number} Calculated Number.
    *###
    curt: () ->
        return @pow(1 / 3)

    curtSelf: () ->
        return @powSelf(1 / 3)

    ###*
    * This method calculates any root of this instance and returns a new one.
    * @method plus
    * @param {Number} exponent
    * @return {Number} Calculated Number.
    *###
    root: (exp) ->
        return @pow(1 / exp)

    rootSelf: (exp) ->
        return @powSelf(1 / exp)

    ###*
    * This method adds 2 numbers and returns a new one.
    * @method plus
    * @param {Number} n
    * @return {Number} Calculated Number.
    *###
    reciprocal: () ->
        return @fromPool( 1 / @value )

    reciprocalSelf: () ->
        @value = 1 / @value
        return @

    ###*
    * This method adds 2 numbers and returns a new one.
    * @method plus
    * @param {Number} n
    * @return {Number} Calculated Number.
    *###
    pow: (n) ->
        return @fromPool mathJS.pow @value, @_getValueFromParam(n)

    powSelf: (n) ->
        @value = mathJS.pow @value, @_getValueFromParam(n)
        return @

    sign: () ->
        return mathJS.sign @value

    toInt: () ->
        return mathJS.Int.fromPool mathJS.floor(@value)

    toDouble: () ->
        return mathJS.Double.fromPool @value

    toString: () ->
        return @value.toString()

    clone: () ->
        return @fromPool @value

    # add instance to pool
    release: () ->
        @constructor._pool.push @
        return @constructor

    # TODO: intercept destructor
    # .....
# end js/Numbers/Number.coffee

# from js/Numbers/Double.coffee
class mathJS.Double extends mathJS.Number

    constructor: (value) ->
        super
# end js/Numbers/Double.coffee

# from js/Numbers/Fraction.coffee
class mathJS.Fraction extends mathJS.Number

    constructor: (enumerator, denominator) ->
        @enumerator = enumerator
        @denominator = denominator
        Object.defineProperty @, "value", {
            # writable: false
            get: () ->
                return @enumerator / @denominator
        }
# end js/Numbers/Fraction.coffee

# from js/Numbers/Int.coffee
###*
 * @class Int
 * @constructor
 * @param {Number} value
 * @extends Number
*###
class mathJS.Int extends mathJS.Number

    ###########################################################################
    # STATIC

    # convert return value of inherited method to integer
    do () =>
        inherited = @_getValueFromParam.bind(@)
        @_getValueFromParam = (value) ->
            return ~~inherited(value)

    # _pool, fromPool are inherited

    @parse: (str) ->
        if mathJS.isNum(parsed = parseIn(str, 10))
            return @fromPool parsed
        return parsed

    @random: (max, min) ->
        return @fromPool mathJS.randInt(max, min)


    ###########################################################################
    # CONSTRUCTOR
    constructor: (value) ->
        super

    ###########################################################################
    # PRIVATE METHODS

    ###########################################################################
    # PROTECTED METHODS

    ###########################################################################
    # PUBLIC METHODS
    plus: (n) ->
        return @constructor.fromPool ~~(@value + @_getValueFromParam(n))

    increase: (n) ->
        @value += ~~@_getValueFromParam(n)
        return @

    plusSelf: @increase

    minus: (n) ->
        return @constructor.fromPool ~~(@value - n)

    decrease: (n) ->
        @value = ~~(@value - @_getValueFromParam(n)) # when rounding is done matters when substracting (in contrary to addition)
        return @

    minusSelf: @decrease

    times: (n) ->
        return @constructor.fromPool ~~(@value * @_getValueFromParam(n))

    timesSelf: (n) ->
        @value = ~~(@value * @_getValueFromParam(n)) # same as substraction
        return @

    divide: (n) ->
        return @constructor.fromPool ~~(@value / @_getValueFromParam(n))

    divideSelf: (n) ->
        @value = ~~(@value / @_getValueFromParam(n))
        return @

    sqrt: () ->
        return @constructor.fromPool ~~(mathJS.sqrt @value)

    sqrtSelf: () ->
        @value = ~~mathJS.sqrt(@value)
        return @

    pow: (n) ->
        return @constructor.fromPool(mathJS.pow @value, @_getValueFromParam(n))

    powSelf: (n) ->
        @value = mathJS.pow @value, @_getValueFromParam(n)
        return @

    toInt: () ->
        return mathJS.Int.fromPool @value
# end js/Numbers/Int.coffee

# from js/Numbers/Complex.coffee
###*
 * @abstract
 * @class Complex
 * @constructor
 * @param {Number} real
 * Real part of the number. Either a mathJS.Number or primitive number.
 * @param {Number} image
 * Real part of the number. Either a mathJS.Number or primitive number.
 * @extends Number
*###
class mathJS.Complex extends mathJS.Number

    PARSE_KEY = "0c"

    ###########################################################################
    # STATIC

    # ###*
    # * @Override
    # *###
    # @_valueIsValid: (value) ->
    #     return value instanceof mathJS.Number or mathJS.isNum(value)

    ###*
    * @Override
    * This method creates an object with the keys 'real' and 'img' which have primitive numbers as their values.
    * @static
    * @method _getValueFromParam
    * @param {Complex|Number} real
    * @param {Number} img
    * @return {Object}
    *###
    @_getValueFromParam: (real, img) ->
        if real instanceof mathJS.Complex
            return {
                real: real.real
                img: real.img
            }

        if real instanceof mathJS.Number and img instanceof mathJS.Number
            return {
                real: real.value
                img: img.value
            }

        if mathJS.isNum(real) and mathJS.isNum(img)
            return {
                real: real
                img: img
            }

        return null


    @fromPool: (real, img) ->
        if @_pool.length > 0
            if @_valueIsValid(real) and @_valueIsValid(img)
                number = @_pool.pop()
                number.real = real
                number.img = img
                return number
            return null
        else
            return new @(real, img)

    @parse: (str) ->
        idx = str.toLowerCase().indexOf(PARSE_KEY)
        if idx >= 0
            parts = str.substring(idx + PARSE_KEY.length).split ","
            if mathJS.isNum(real = parseFloat(parts[0])) and mathJS.isNum(img = parseFloat(parts[1]))
                return @fromPool real, img

        return NaN

    @random: (max1, min1, max2, min2) ->
        return @fromPool mathJS.randNum(max1, min1), mathJS.randNum(max2, min2)


    ###########################################################################
    # CONSTRUCTOR
    constructor: (real, img) ->
        values = @_getValueFromParam(real, img)

        if not values?
            fStr = arguments.callee.caller.toString()
            throw new Error("mathJS: Expected 2 numbers or a complex number! Given (#{real}, #{img}) in '#{fStr.substring(0, fStr.indexOf(")") + 1)}'")

        Object.defineProperties @, {
            real:
                get: @_getReal
                set: @_setReal
            img:
                get: @_getImg
                set: @_setImg
            fromPool:
                value: @constructor.fromPool.bind(@constructor)
                writable: false
                enumarable: false
                configurable: false
        }

        @real = values.real
        @img = values.img

    ###########################################################################
    # PRIVATE METHODS

    ###########################################################################
    # PROTECTED METHODS
    _setReal: (value) ->
        if @_valueIsValid(value)
            @_real = value.value or value.real or value
        return @

    _getReal: () ->
        return @_real

    _setImg: (value) ->
        if @_valueIsValid(value)
            @_img = value.value or value.img or value
        return @

    _getImg: () ->
        return @_img

    _getValueFromParam: @_getValueFromParam


    ###########################################################################
    # PUBLIC METHODS

    ###*
    * This method check for mathmatical equality. This means new mathJS.Double(4.2).equals(4.2)
    * @method equals
    * @param {Number} n
    * @return {Boolean}
    *###
    equals: (r, i) ->
        values = @_getValueFromParam(r, i)
        if values?
            return @real is values.real and @img is values.img
        return false

    plus: (r, i) ->
        values = @_getValueFromParam(r, i)
        if values?
            return @fromPool(@real + values.real, @img + values.img)
        return NaN

    increase: (r, i) ->
        values = @_getValueFromParam(r, i)
        if values?
            @real += values.real
            @img += values.img
        return @

    plusSelf: @increase

    minus: (n) ->
        values = @_getValueFromParam(r, i)
        if values?
            return @fromPool(@real - values.real, @img - values.img)
        return NaN

    decrease: (n) ->
        values = @_getValueFromParam(r, i)
        if values?
            @real -= values.real
            @img -= values.img
        return @

    minusSelf: @decrease

    # TODO: adjust last functions for complex numbers
    times: (r, i) ->
        # return @fromPool(@value * _getValueFromParam(n))
        values = @_getValueFromParam(r, i)
        if values?
            return @fromPool(@real * values.real, @img * values.img)
        return NaN

    timesSelf: (n) ->
        @value *= _getValueFromParam(n)
        return @

    divide: (n) ->
        return @fromPool(@value / _getValueFromParam(n))

    divideSelf: (n) ->
        @value /= _getValueFromParam(n)
        return @

    square: () ->
        return @fromPool(@value * @value)

    squareSelf: () ->
        @value *= @value
        return @

    cube: () ->
        return @fromPool(@value * @value * @value)

    squareSelf: () ->
        @value *= @value * @value
        return @

    sqrt: () ->
        return @fromPool(mathJS.sqrt @value)

    sqrtSelf: () ->
        @value = mathJS.sqrt @value
        return @

    pow: (n) ->
        return @fromPool(mathJS.pow @value, _getValueFromParam(n))

    powSelf: (n) ->
        @value = mathJS.pow @value, _getValueFromParam(n)
        return @

    sign: () ->
        return mathJS.sign @value

    toInt: () ->
        return mathJS.Int.fromPool mathJS.floor(@value)

    toDouble: () ->
        return mathJS.Double.fromPool @value

    toString: () ->
        return "#{PARSE_KEY}#{@real.toString()},#{@img.toString()}"

    clone: () ->
        return @fromPool(@value)

    # add instance to pool
    release: () ->
        @constructor._pool.push @
        return @constructor
# end js/Numbers/Complex.coffee

# from js/Set/Set.coffee
###*
* @class Set
* @constructor
* @param {Function|Class} type
* @param {Set} universe
* Optional. If given, the created Set will be interpreted as a sub set of the universe.
* @param {Set|Array} elems
* Optional. This parameter serves as elements for the new Set. They will be in the new Set immediately.
* Values can be a Set or an array of comparable elements (that means if `mathJS.isComparable() === true`).
*###
class mathJS.Set extends mixOf mathJS.Poolable, mathJS.Comparable, mathJS.Parseable
    ###########################################################################
    # STATIC

    @disjoint: (set1, set2) ->
        return set1.intersects set2

    ###########################################################################
    # CONSTRUCTOR
    constructor: (leftBoundary, rightBoundary, elems) ->
        @leftBoundary = leftBoundary
        @rightBoundary = rightBoundary

        @_discreteSet = new mathJS.DiscreteSet()
        @_conditionalSet = new mathJS.DiscreteSet() # => empty set


        Object.defineProperties @, {
            _universe:
                value: null
                enumarable: false
            universe:
                get: () ->
                    return @_universe
                set: (universe) ->
                    if universe instanceof mathJS.Set or universe is null
                        @_universe = universe
                    return @
                enumerable: true
        }

        if elems?
            if elems instanceof mathJS.Set
                _unionSelf elems
            else if elems instanceof Array
                true
            # single element (but no set)
            else if mathJS.isComparable elems
                true

        # calc size for caching
        @_cachedSize = @size()

        # if type instanceof mathJS.Comparable
        #     @type = type
        #     @universe = universe
        #     @leftBoundary = leftBoundary
        #     @rightBoundary = rightBoundary
        #     if elems.length > 0
        #         @subsets = [new mathJS.DiscreteSet(type, universe, elems...)]
        #     else
        #         @subsets = []
        #     # calc size for caching
        #     @cachedSize = @size()
        # else
        #     throw new Error("Wrong (incomparable) type given ('#{type.name}'')! Sets must consist of comparable elements!")

    ###########################################################################
    # PRIVATE METHODS

    ###########################################################################
    # PROTECTED METHODS
    _addElem: (elem) ->
        if mathJS.isComparable elem
            true

    # like union but in place => it changes this set
    _unionSelf: () ->



    addElems: (elems) ->
        set = new mathJS.EmptySet()
        for elem in elems when elem instanceof @type
            set.addElem elem


    ###########################################################################
    # PUBLIC METHODS

    clone: () ->
        # TODO
        throw new Error("todo!")
        return

    equals: (set) ->
        # TODO
        throw new Error("todo!")

    addElem: (elem) ->
        if elem instanceof @type
            return @union(new mathJS.DiscreteSet(@type, elem))
        return @
        # elem = @_getValueFromParam(elem)
        #
        # if elem?
        #     for subset in @subsets
        #         # element already in some subset => return
        #         if subset.contains elem
        #             return @
        #
        #     # element is in no subset and not in elements
        #     for e in @elems when e.equals?(elem) or e is elem
        #         return @
        #
        #     # at this point we know that the element is not in the set
        #     @elems.push elem
        #
        # return @

    # addElems: (elems) ->
    #     set = new mathJS.EmptySet()
    #     for elem in elems when elem instanceof @type
    #         set.addElem elem



    removeElem: (elem) ->
        if elem instanceof @type
            return @without(new mathJS.DiscreteSet(@type, elem))
            # subset.remove elem for subset in @subsets
            #
            # elems = []
            # for e in @elems
            #     if e.equals(elem) or e is elem
            #         continue
            #     elems.push e
            #
            # @elems = elems
        return @

    contains: (elem) ->
        if elem instanceof @type
            for subset in @subsets
                if subset.contains elem
                    return true
        return false

    in: @::contains

    union: (set) ->
        # TODO: how to avoid doubles?
        # see if the set matches any already existing set
        if @intersects set
            # remove duplicates from given set
            set = set.without @
            @subsets.push set
        # disjoint sets
        else
            @subsets.push set

        return @

    intersect: (set) ->
        return

    intersects: (set) ->
        return @intersection.size() > 0

    disjoint: (set) ->
        return @intersection.size() is 0

    complement: () ->
        if @universe?
            return asdf
        return new mathJS.EmptySet()
    ###*
    * a.without b => returns: removed all common elements from a
    *###
    without: (set) ->

    cartesianProduct: (set) ->

    times: @::cartesianProduct

    size: () ->
        return @_discreteSet.size() + @_conditionalSet.size()

    isEmpty: () ->
        return @size() > 0

    cardinality: @::size

    makeToDiscreteSet: () ->
        @.__proto__ = mathJS.DiscreteSet.prototype
        return @

    makeToConditionalSet: () ->
        @.__proto__ = mathJS.ConditionalSet.prototype
        return @

#
#
# ###*
#  * This is an implementation of a dictionary/hash that does not convert its keys into Strings. Keys can therefore actually by anything! :)
#  * @class Configurator
#  * @constructor
# *###
# class App.Hash
#
#     constructor: () ->
#         @keys = []
#         @values = []
#
#     ###*
#      * Creates a new Hash from a given JavaScript object.
#      * @static
#      * @method fromObject
#      * @param object {Object}
#     *###
#     @fromObject: (obj) ->
#         hash = new Hash()
#         for key, val of obj
#             hash.put key, val
#         return hash
#
#     ###*
#      * Adds a new key-value pair or overwrites an existing one.
#      * @private
#      * @method _putObject
#      * @param object {Object}
#      * @return {Hash} This instance.
#      * @chainable
#     *###
#     _putObject = (obj) ->
#         for key, val of obj
#             @put key, val
#         return @
#
#     ###*
#      * Adds a new key-value pair or overwrites an existing one.
#      * @method put
#      * @param key {mixed}
#      * @param val {mixed}
#      * @return {Hash} This instance.
#      * @chainable
#     *###
#     put: (key, val) ->
#         # no value given => assume an object was passed
#         if not val?
#             return _putObject.call(@, key)
#
#         idx = @keys.indexOf key
#         # add new entry
#         if idx < 0
#             @keys.push key
#             @values.push val
#         # overwrite entry
#         else
#             @keys[idx] = key
#             @values[idx] = val
#
#         return @
#
#     ###*
#      * Returns the value (or null) for the specified key.
#      * @method get
#      * @param key {mixed}
#      * @param [equalityFunction] {Function}
#      * This optional function can overwrite the test for equality between keys. This function expects the parameters ('key' and the current key in the key iteration). If this parameters is omitted '===' is used.
#      * @return {mixed}
#     *###
#     get: (key, eqFunc) ->
#         if not eqFunc?
#             idx = @keys.indexOf key
#         else
#             idx = (i for k, i in @keys when eqFunc(key, k) is true)[0]
#
#         if idx >= 0
#             return @values[idx]
#
#         return null
#
#     ###*
#      * Returns a list of all key-value pairs. Each pair is an Array with the 1st element being the key, the 2nd being the value.
#      * @method getAll
#      * @return {Array} Key-value pairs.
#     *###
#     getAll: () ->
#         res = []
#
#         for key, idx in @keys
#             res.push [ key, @values[idx] ]
#
#         return res
#
#     ###*
#      * Indicates whether the Hash has the specified key.
#      * @method hasKey
#      * @param key {mixed}
#      * @return {Boolean}
#     *###
#     hasKey: (key) ->
#         return key in @keys
#
#     ###*
#      * Returns the number of entries in the Hash.
#      * @method size
#      * @return {Integer}
#     *###
#     size: () ->
#         return @keys.length
#
#     ###*
#      * Returns all the keys of the Hash.
#      * @method getKeys()
#      * @return {Array}
#     *###
#     getKeys: () ->
#         return @keys
#
#     ###*
#      * Returns all the values of the Hash.
#      * @method getValues()
#      * @return {Array}
#     *###
#     getValues: () ->
#         return @values
#
#     ###*
#      * Returns a list of keys that have val (or anything equal as specified in 'eqFunc') as value.
#      * @method getKeysForValue
#      * @param val {mixed}
#      * @param [equalityFunction] {Function}
#      * This optional function can overwrite the test for equality between values. This function expects the parameters ('value' and the current value in the value iteration). If this parameters is omitted '===' is used.
#      * @return {mixed}
#     *###
#     getKeysForValue: (value, eqFunc) ->
#         if not eqFunc?
#             idxs = (idx for val, idx in @values when val is value)
#         else
#             idxs = (idx for val, idx in @values when eqFunc(val, value) is true)
#
#         res = []
#         res.push(@keys[idx]) for idx in idxs
#
#         return res
# end js/Set/Set.coffee

# from js/Set/EmptySet.coffee
class mathJS.EmptySet extends mathJS.Set

    ###*
    * @Override
    * see mathJS.Poolable
    * @static
    * @method fromPool
    *###
    @fromPool: () ->
        if @_pool.length > 0
            return @_pool.pop()
        return new @()

    @new: () ->
        return @fromPool()

    ###########################################################################################
    # CONSTRUCTOR
    constructor: () ->

    ###########################################################################################
    # PUBLIC METHODS
    clone: () ->
        return mathJS.EmptySet.new()

    equals: (set) ->
        return set instanceof mathJS.EmptySet

    addElem: (elem) ->
        if DEBUG
            console.warn "prototype change!"
        @makeToDiscreteSet()
        return @

    addElems: (elems) ->
        set = mathJS.EmptySet.new()
        for elem in elems when elem instanceof @type
            set.addElem elem

    removeElem: (elem) ->
        if elem instanceof @type
            return @without(new mathJS.DiscreteSet(@type, elem))
            # subset.remove elem for subset in @subsets
            #
            # elems = []
            # for e in @elems
            #     if e.equals(elem) or e is elem
            #         continue
            #     elems.push e
            #
            # @elems = elems
        return @

    contains: (elem) ->
        if elem instanceof @type
            for subset in @subsets
                if subset.contains elem
                    return true
        return false

    union: (set) ->
        # TODO: how to avoid doubles?
        # see if the set matches any already existing set
        if @intersects set
            # remove duplicates from given set
            set = set.without @
            @subsets.push set
        # disjoint sets
        else
            @subsets.push set

        return @

    intersect: (set) ->
        return mathJS.EmptySet.new()

    intersects: (set) ->
        return false

    disjoint: (set) ->
        return true

    complement: () ->
        if @universe?
            return @universe
        return mathJS.EmptySet.new()
        
    ###*
    * a.without b => returns: removed all common elements from a
    *###
    without: (set) ->
        return

    size: () ->
        return 0

    ###*
    * @Override mathJS.Poolable
    * see mathJS.Poolable
    * @method release
    *###
    release: () ->
        @constructor._pool.push @
        return @constructor
# end js/Set/EmptySet.coffee

# from js/Set/DiscreteSet.coffee
###*
* This class is a Setof explicitely listed elements (with no needed logic).
* @class DiscreteSet
* @constructor
* @param {Function|Class} type
* @param {Set} universe
* Optional. If given, the created Set will be interpreted as a sub set of the universe.
* @param {mixed} elems...
* Optional. This and the following parameters serve as elements for the new Set. They will be in the new Set immediately.
* @extends Set
*###
class mathJS.DiscreteSet extends mathJS.Set

    ###########################################################################
    # CONSTRUCTOR
    constructor: (type, universe, elems...) ->
        # if type instanceof mathJS.Comparable
        #     @type = type
        #     @universe = universe
        #     @subsets = []
        # else
        #     throw new Error("Wrong (incomparable) type given ('#{type.name}')! Sets must consist of comparable elements!")

    ###########################################################################
    # PROTECTED METHODS


    ###########################################################################
    # PUBLIC METHODS
    getElements: () ->
        return @elems

    ###*
    * @Override
    *###
    equals: (set) ->
        throw new Error("todo!")

    addElem: (elem) ->
        if elem instanceof @type
            return @union(new mathJS.DiscreteSet(@type, elem))
        return @
        # elem = @_getValueFromParam(elem)
        #
        # if elem?
        #     for subset in @subsets
        #         # element already in some subset => return
        #         if subset.contains elem
        #             return @
        #
        #     # element is in no subset and not in elements
        #     for e in @elems when e.equals?(elem) or e is elem
        #         return @
        #
        #     # at this point we know that the element is not in the set
        #     @elems.push elem
        #
        # return @

    removeElem: (elem) ->
        if elem instanceof @type
            return @without(new mathJS.DiscreteSet(@type, elem))
            # subset.remove elem for subset in @subsets
            #
            # elems = []
            # for e in @elems
            #     if e.equals(elem) or e is elem
            #         continue
            #     elems.push e
            #
            # @elems = elems
        return @

    contains: (elem) ->
        if elem instanceof @type
            for e in @elems when e.equals(elem)
                return true
        return false

    in: @::contains

    unionSelf: (set) ->
        if set instanceof mathJS.DiscreteSet
            # some common elements
            if (intersection = @intersect(set)).size() > 0
                @elems.push.apply @elems, set.without intersection
            # disjoint sets => add 'em all
            else
                @elems.push.apply @elems, set.elems
        else if set instanceof mathJS.ConditionalSet

        else if set instanceof mathJS.EmptySet
            return
        # TODO: how to avoid doubles?
        # see if the set matches any already existing set
        # if @intersects set
        #     # remove duplicates from given set
        #     set = set.without @
        #     @subsets.push set
        # # disjoint sets
        # else
        #     @subsets.push set
        #
        # return @

    intersect: (set) ->
        if set instanceof mathJS.DiscreteSet
            elems = []
            for x in @elems
                for y in set.elems
                    if x.equals y
                        elems.push x
            if elems.length > 0
                res = new mathJS.DiscreteSet(@type, @universe)



        else if set instanceof mathJS.ConditionalSet

        else if set instanceof mathJS.EmptySet
            return new mathJS.EmptySet()
        return null



    complement: () ->
        if @universe?
            return
        return new mathJS.EmptySet()
    ###*
    * a.without b => returns: removed all common elements from a
    *###
    without: (set) ->


    size: () ->
        # return @elems.length
        return 42
# end js/Set/DiscreteSet.coffee

# from js/Set/ConditionalSet.coffee
class mathJS.ConditionalSet extends mathJS.Set

    constructor: (args) ->
        # body...
# end js/Set/ConditionalSet.coffee

# from js/Function.coffee
class mathJS.Function extends mathJS.ConditionalSet

    constructor: (fromSet, toSet, mapping) ->
        @fromSet = fromSet
        @toSet = toSet
        @mapping = mapping
# end js/Function.coffee

# from js/Vector.coffee
class mathJS.Vector

    constructor: () ->
        # body...


# make name alias for Tuple
class mathJS.Tuple extends mathJS.Vector
# end js/Vector.coffee

# from js/start.coffee
$(document).ready () ->
	# window.g = new TD.Game()
	console.log "dom ready"
# end js/start.coffee

