#################################################################################################
# THIS FILE CONTAINS ALL PROPERITES AND FUNCTIONS THAT ARE BOUND DIRECTLY TO mathJS
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
