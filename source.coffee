# from js/init.coffee
###*
 * @module mathJS
 * @main mathJS
*###

if typeof DEBUG is "undefined"
    window.DEBUG = true

# create namespaces
window.mathJS =
    Algorithms: {}
    Domains: {} # contains instances of sets
    Errors: {}
    Geometry: {}
    Operations: {}
    Sets: {}
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
# TODO: use object.defineProperties in order to hide methods from enumeration
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

# convenient index getters and setters
Object.defineProperties Array::, {
    first:
        get: () ->
            return @[0]
        set: (val) ->
            @[0] = val
            return @
}

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

Array::sortProp = (getProp, order = "asc") ->
    if not getProp?
        getProp = (item) ->
            return item

    if order is "asc"
        cmpFunc = (a, b) ->
            a = getProp(a)
            b = getProp(b)
            if a < b
                return -1
            if b > a
                return 1
            return 0
    else
        cmpFunc = (a, b) ->
            a = getProp(a)
            b = getProp(b)
            if a > b
                return -1
            if b < a
                return 1
            return 0

    return @sort cmpFunc


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

#######################################################################
# OBJECT

Object.keysLike = (obj, pattern) ->
    res = []
    for key in Object.keys(obj)
        if pattern.test key
            res.push key
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
    id:
        value: (x) ->
            return x
        writable: false

    # number sets / systems
    # N:
    #     value: new mathJS.Set()
    #     writable: false
}

mathJS.isPrimitive = (x) ->
    return typeof x is "string" or typeof x is "number" or typeof x is "boolean"

mathJS.isComparable = (x) ->
    # return x instanceof mathJS.Comparable or x.instanceof?(mathJS.Comparable) or mathJS.isPrimitive x
    return x.equals instanceof Function or mathJS.isPrimitive x

mathJS.instanceof = (instance, clss) ->
    return instance instanceof clss or instance.instanceof?(clss)

mathJS.equals = (x, y) ->
    return x.equals?(y) or y.equals?(x) or x is y

mathJS.greaterThan = (x, y) ->
    return x.gt?(y) or y.lt?(x) or x > y

mathJS.gt = mathJS.greaterThan

mathJS.lessThan = (x, y) ->
    return x.lt?(y) or y.gt?(x) or x < y

mathJS.lt = mathJS.lessThan

mathJS.ggT = () ->
    if arguments[0] instanceof Array
        vals = arguments[0]
    else
        vals = Array::slice.apply arguments

    if vals.length is 2
        if vals[1] is 0
            return vals[0]
        return mathJS.ggT(vals[1], vals[0] %% vals[1])
    else if vals.length > 2
        ggt = mathJS.ggT vals[0], vals[1]
        for i in [2...vals.length]
            ggt = mathJS.ggT(ggt, vals[i])
        return ggt
    return null

mathJS.gcd = mathJS.ggT

mathJS.kgV = () ->
    if arguments[0] instanceof Array
        vals = arguments[0]
    else
        vals = Array::slice.apply arguments

    if vals.length is 2
        return vals[0] * vals[1] // mathJS.ggT(vals[0], vals[1])
    else if vals.length > 2
        kgv = mathJS.kgV vals[0], vals[1]
        for i in [2...vals.length]
            kgv = mathJS.kgV(kgv, vals[i])
        return kgv
    return null

mathJS.lcm = mathJS.kgV

mathJS.coprime = (x, y) ->
    return mathJS.gcd(x, y) is 1


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

mathJS.factorial = (n) ->
    if (n = ~~n) < 0
        return NaN
    return mathJS.factorial.cache[n] or (mathJS.factorial.cache[n] = n * mathJS.factorial(n - 1))

# initial cache (dynamically growing when exceeded)
mathJS.factorial.cache = [
    1
    1
    2
    6
    24
    120
    720
    5040
    40320
    362880
    3628800
    39916800
    4.790016e8
    6.2270208e9
    8.71782912e10
    1.307674368e12
]

# make alias
mathJS.fac = mathJS.factorial

mathJS.parseNumber = (str) ->
    # TODO
    return null

mathJS.factorialInverse = (n) ->
    if (n = ~~n) < 0
        return NaN
        
    x = 0
    # js: while((y = mathJS.factorial(++x)) < n) {}
    while (y = mathJS.factorial(++x)) < n then

    if y is n
        return parseInt(x, 10)

    return NaN

# make alias
mathJS.facInv = mathJS.factorialInverse


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

mathJS.isMathJSNum = (n) ->
    return n? and (isFinite(n) or n instanceof mathJS.Number or n.instanceof(mathJS.Number))

mathJS.isInt = (r) ->
    return mathJS.isNum(r) and ~~r is r

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
    n = n.value or n
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

# from js/settings.coffee
mathJS.settings =
    set:
        maxIterations: 1e3
        maxMatches: 60
    integral:
        maxSteps: 1e10
# end js/settings.coffee

# from js/Algorithms/ShuntingYard.coffee
# from http://rosettacode.org/wiki/Parsing/Shunting-yard_algorithm
class mathJS.Algorithms.ShuntingYard

    CLASS = @

    @specialOperators =
        # unary plus/minus
        "+" : "#"
        "-" : "_"

    constructor: (settings) ->
        @ops = ""
        @precedence = {}
        @associativity = {}

        for op, opSettings of settings
            @ops += op
            @precedence[op] = opSettings.precedence
            @associativity[op] = opSettings.associativity

    toPostfix: (str) ->
        # remove spaces
        str = str.replace /\s+/g, ""

        stack = []
        ops = @ops
        precedence = @precedence
        associativity = @associativity
        postfix = ""

        for token, i in str
            # if token is operand (here limited to 0 <= x <= 9)
            if token > "0" and token < "9"
                postfix += "#{token} "
            # if token is an operator
            else if token in ops
                o1 = token
                o2 = stack.last()

                # handle unary plus/minus => just add special char
                if i is 0 or prevToken is "("
                    if CLASS.specialOperators[token]?
                        postfix += "#{CLASS.specialOperators[token]} "
                    # if token is "-"
                    #     postfix += "_ "
                    # else if token is "+"
                    #     postfix += "# "
                else
                    # while operator token, o2, on top of the stack
                    # and o1 is left-associative and its precedence is less than or equal to that of o2
                    # (the algorithm on wikipedia says: or o1 precedence < o2 precedence, but I think it should be)
                    # or o1 is right-associative and its precedence is less than that of o2
                    while o2 in ops and (associativity[o1] is "left" and precedence[o1] <= precedence[o2]) or (associativity[o1] is "right" and precedence[o1] < precedence[o2])
                        # add o2 to output queue
                        postfix += "#{o2} "
                        # pop o2 of the stack
                        stack.pop()
                        # next round
                        o2 = stack.last()
                    # push o1 onto the stack
                    stack.push(o1)
            # if token is left parenthesis
            else if token is "("
                # then push it onto the stack
                stack.push(token)
            # if token is right parenthesis
            else if token is ")"
                # until token at top is (
                while stack.last() isnt "("
                    postfix += "#{stack.pop()} "
                # pop (, but not onto the output queue
                stack.pop()

            prevToken = token

            # console.log token, stack

        while stack.length > 0
          postfix += "#{stack.pop()} "

        return postfix

    toExpression: (str) ->
        postfix = @toPostfix(str)
# end js/Algorithms/ShuntingYard.coffee

# from js/Errors/SimpleErrors.coffee
class mathJS.Errors.CalculationExceedanceError extends Error

class mathJS.Errors.InvalidVariableError extends Error

class mathJS.Errors.InvalidParametersError extends Error

class mathJS.Errors.InvalidArityError extends Error
# end js/Errors/SimpleErrors.coffee

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

# from js/interfaces/Evaluable.coffee
class mathJS.Evaluable

    eval: () ->
        throw new Error("to do!")
# end js/interfaces/Evaluable.coffee

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
    @valueIsValid: (value) ->
        return value instanceof mathJS.Number or mathJS.isNum(value)

    ###*
    * This method gets the value from a parameter. The validity is determined by this.valueIsValid().
    * @static
    * @protected
    * @method _getValueFromParam
    * @param {Number} param
    * @param {Boolean} skipCheck
    * If `true` the given parameter is not (again) checked for validity. If the function that calls _getValueFromParam() has already checked the passed parameter this `skipCheck` should be set to true.
    * @return {Number} The primitive value or null.
    *###
    @_getValueFromParam: (param, skipCheck) ->
        if not skipCheck and not @valueIsValid(param)
            return null

        if param instanceof mathJS.Number
            value = param.value
        else if param instanceof Number
            value = param.valueOf()
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
            if @valueIsValid val
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

    @toNumber: (n) ->
        if n instanceof mathJS.Number
            return n
        return new mathJS.Number(n)



    ###########################################################################
    # CONSTRUCTOR
    constructor: (value) ->
        if not @valueIsValid(value)
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
        if @valueIsValid(value)
            @_value = @_getValueFromParam(value, true)
        return @

    _getValue: () ->
        return @_value

    # link to static methods
    valueIsValid: @valueIsValid

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

    # EVALUABLE INTERFACE
    eval: (values) ->
        return @

    # TODO: intercept destructor
    # .....
# end js/Numbers/Number.coffee

# from js/Numbers/Double.coffee
class mathJS.Double extends mathJS.Number

    # constructor: (value) ->
    #     super
# end js/Numbers/Double.coffee

# from js/Numbers/Float.coffee
class mathJS.Float extends mathJS.Double
# end js/Numbers/Float.coffee

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
    isEven: () ->
        return @value %% 2 is 0

    isOdd: () ->
        return @value %% 2 is 1


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
# TODO: maybe extend mathJS.Vector instead?! or mix 'em
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

# from js/Formals/Variable.coffee
###*
* @class Variable
* @constructor
* @param {String} name
* This is name name of the variable (mathematically)
* @param {Function|Class} type
* @param {Object} value
* Optional. This param is passed upon evaluation.
*###
# TODO: make interfaces meta: eg. have a Variable@Evaluable.coffee file that contains the interface and inset on build
class mathJS.Variable extends mathJS.Evaluable

    constructor: (name, type=mathJS.Number) ->
        @name = name
        @type = type

    plus: (n) ->
        return new mathJS.Expression("+", @, n)

    eval: (values) ->
        if values? and (val = values[@name])?
            if val not instanceof @type
                console.warn "Given value '#{val}' doesn't match variable type '#{@type.name}'."
            return val

        return @
# end js/Formals/Variable.coffee

# from js/Formals/Operation.coffee
class mathJS.Operation

    constructor: (name, precedence, associativity="left", commutative, func, inverse) ->
        @name = name
        @precedence = precedence
        @associativity = associativity
        @commutative = commutative
        @func = func
        @arity = func.length # number of parameters => unary, binary, ternary...
        @inverse = inverse or null

    eval: (args) ->
        return @func.apply(@, args)

    invert: () ->
        if @inverse?
            return @inverse.apply(@, arguments)
        return null

# ABSTRACT OPERATIONS
# Those functions make sure primitives are converted correctly and calls the according operation on it's first argument.
# They are the actual functions of the operations.
# TODO: no DRY
mathJS.Abstract =
    Operations:
        divide: (x, y) ->
            if mathJS.Number.valueIsValid(x) and mathJS.Number.valueIsValid(y)
                x = new mathJS.Number(x)
                y = new mathJS.Number(y)
            return x.divide(y)
        minus: (x, y) ->
            if mathJS.Number.valueIsValid(x) and mathJS.Number.valueIsValid(y)
                x = new mathJS.Number(x)
                y = new mathJS.Number(y)
            return x.minus(y)
        plus: (x, y) ->
            # numbers -> convert to mathJS.Number
            # => int to real
            if mathJS.Number.valueIsValid(x) and mathJS.Number.valueIsValid(y)
                x = new mathJS.Number(x)
                y = new mathJS.Number(y)
            # else if x instanceof mathJS.Variable or y instanceof mathJS.Variable
            #     return new mathJS.Expression(mathJS.Operations.plus, x, y)
            # else if x.plus?
            #     return x.plus(y)
            return x.plus(y)
            # throw new mathJS.Errors.InvalidParametersError("...")
        times: (x, y) ->
            # numbers -> convert to mathJS.Number
            # => int to real
            if mathJS.Number.valueIsValid(x) and mathJS.Number.valueIsValid(y)
                x = new mathJS.Number(x)
                y = new mathJS.Number(y)
            return x.times(y)

###
PRECEDENCE (top to bottom):
(...)
factorial
unary +/-
exponents, roots
multiplication, division
addition, subtraction
###

cached =
    division: new mathJS.Operation(
        "divide"
        1
        "left"
        false
        mathJS.pow
        mathJS.root
    )
    addition: new mathJS.Operation(
        "plus"
        1
        "left"
        true
        mathJS.Abstract.Operations.plus
        mathJS.Abstract.Operations.minus
    )
    subtraction: new mathJS.Operation(
        "plus"
        1
        "left"
        false
        mathJS.Abstract.Operations.minus
        mathJS.Abstract.Operations.plus
    )
    multiplication: new mathJS.Operation(
        "times"
        1
        "left"
        true
        mathJS.Abstract.Operations.times
        mathJS.Abstract.Operations.divide
    )
    exponentiation: new mathJS.Operation(
        "pow"
        1
        "right"
        false
        mathJS.pow
        mathJS.root
    )
    factorial: new mathJS.Operation(
        "factorial"
        10
        "right"
        false
        mathJS.factorial
        # TODO: inverse function
        null
    )


mathJS.Operations =
    "+":        cached.addition
    "plus":     cached.addition
    "-":        cached.subtraction
    "minus":    cached.subtraction
    "*":        cached.multiplication
    "times":    cached.multiplication
    "/":        cached.division
    ":":        cached.division
    "divide":   cached.division
    "^":        cached.exponentiation
    "pow":      cached.exponentiation
    "!":        cached.factorial
# end js/Formals/Operation.coffee

# from js/Formals/Expression.coffee
###*
* Tree structure of expressions. It consists of 2 expression and 1 operation.
* @class Expression

*###
class mathJS.Expression

    CLASS = @

    @fromString: (str) ->
        # TODO: parse string
        return new mathJS.Expression()

    @parse = @fromString

    @parser = new mathJS.Algorithms.ShuntingYard(
    # TODO: use operations from operation class
        "!":
            precedence: 5
            associativity: "right"
        "^":
            precedence: 4
            associativity: "right"
        "*":
            precedence: 3
            associativity: "left"
        "/":
            precedence: 3
            associativity: "left"
        "+":
            precedence: 2
            associativity: "left"
        "-":
            precedence: 2
            associativity: "left"
    )


    # TODO: make those meaningful: eg. adjusted parameter lists?!
    @new: (operation, expressions...) ->
        return new CLASS(operation, expressions)

    constructor: (operation, expressions...) ->
        # map op string to actual operation object
        if typeof operation is "string"
            if mathJS.Operations[operation]?
                operation = mathJS.Operations[operation]
            else
                throw new InvalidParametersError("Invalid operation string given: '#{operation}'.")

        # if constructor was called from static .new()
        if expressions.first instanceof Array
            expressions = expressions.first

        # just 1 parameter => constant/value or hash given
        if expressions.length is 0
            # TODO: Variables
            # constant/variable value given => leaf in expression tree
            if mathJS.Number.valueIsValid(operation)
                @operation = null
                @expressions = [new mathJS.Number(operation)]
            else if operation instanceof mathJS.Variable
                @operation = null
                @expressions = [operation]
            else
                throw new mathJS.Errors.InvalidParametersError("...")

        else if operation.arity is expressions.length
            @operation = operation
            @expressions = expressions
        else
            throw new mathJS.Errors.InvalidArityError("Invalid number of parameters (#{expressions.length}) for Operation '#{operation.name}'. Expected number of parameters is #{operation.arity}.")


    ###*
    * @method eval
    * @param values {Object}
    * An object of the form {varKey: varVal}.
    * @returns The value of the expression (specified by the values).
    *###
    eval: (values) ->
        # replace primitives with mathJS objects
        for k, v of values
            if mathJS.isPrimitive(v) and mathJS.Number.valueIsValid(v)
                values[k] = new mathJS.Number(v)

        # leaf => first expression is either a mathJS.Variable or a constant (-> Number)
        if not @operation?
            return @expressions.first.eval(values)

        # no leaf => eval substrees
        args = []
        for expression in @expressions
            # evaluated expression is a variable => stop because this and the 'above' expression can't be evaluated further
            value = expression.eval(values)
            if value instanceof mathJS.Variable
                return @
            # evaluation succeeded => add to list of evaluated values (which will be passed to the operation)
            args.push value

        return @operation.eval(args)

    simplify: () ->
        # TODO
        return @

    if DEBUG
        @test = () ->
            # e1 = new CLASS(5)
            # e2 = new CLASS(2)
            # e3 = new CLASS(4)
            # e4 = new CLASS("+", e1, e2)
            # console.log e4.eval()
            # e5 = new CLASS("*", e4, e3)
            # # e5 = (5 + 2) * 4 = 28
            # console.log e5.eval()
            #
            # e1 = new CLASS(5)
            # e2 = new CLASS(new mathJS.Variable("x", mathJS.Number))
            # e4 = new CLASS("+", e1, e2)
            # console.log e4.eval({x: new mathJS.Number(5)})
            # console.log e4.eval()
            # e5 = e4.eval()
            # console.log e5.eval({x: new mathJS.Number(5)})

            str = "(5x - 3)  ^ 2 * 2 / (4y + 3!)"

            # (5x-3)^2 * 2 / (4y + 6)

            return "test done"
# end js/Formals/Expression.coffee

# from js/Formals/Equation.coffee
class mathJS.Equation

    constructor: (expression1, expression2) ->
        @expression1 = expression1
        @expression2 = expression2
# end js/Formals/Equation.coffee

# from js/Set/SetSpec.coffee
class mathJS.SetSpec

    # f is mapping (bijection to N)
    constructor: (isFinite, f, f2) ->
        if isFinite is true or isFinite is "true"
            @isFinite = true
            @checker = f
            @generator = f2

        else if isFinite is false or isFinite is "false"
            @checker = f
            if isFinite is true
                @generator = generator
        else
            debugger
            throw new Error("mathJS: Expected (Function, boolean) for SetSpec! Given #{check} and #{isFinite}")

class mathJS.SetBuilder

    constructor: (expression, domain, conditions...) ->
        # try to evaluate conditions??
        


###
{7,3,15,31}
{a,b,c}
{1,2,3,...,100}
{0,1,2,...}

{x : x in R and x = x^2 } or {x | x in R and x = x^2 }
{ (x,y) | 0 < y < f(x) }
{ (t,2t+1) | t in Z }

[a,b] = { x | x in R and a <= x <= b }

equal predicates <=> equal sets (if expressions (in front) also equal)!!!
{ x | x in R and |x| = 1 } <=> { x | x in R and x^2 = 1 }


dicht oder nicht?
nicht dicht + bounded => diskret
N -> left boundary
mathJS.Root class for difference Q <-> R


###
# end js/Set/SetSpec.coffee

# from js/Set/Set.coffee
###*
* @class Set
* @constructor
* @param {Object} boundarySettings
* @param {Function} condition
* Optional. If given, the created Set will bounded by that condition
* @param {Array} elems
* Optional. This parameter serves as elements for the new Set. They will be in the new Set immediately.
* It is an array of comparable elements (that means if `mathJS.isComparable() === true`); non-comparables will be ignored.
*###
class mathJS.Set extends mixOf mathJS.Poolable, mathJS.Comparable, mathJS.Parseable
    ###########################################################################
    # STATIC

    # @disjoint: (set1, set2) ->
    #     return set1.intersects set2

    # predefined set conditions (should be used!)
    # @isInt: new mathJS.SetSpec(
    #     (x) ->
    #         return new mathJS.Int(x).equals(x)
    #     false
    # )
    # @range: new mathJS.SetSpec(
    #     (x) ->
    #         return new mathJS.Int(x).equals(x)
    #     false
    # )


    @_isSet = (set) ->
        return set instanceof mathJS.Set or set.instanceof(mathJS.Set)

    ###########################################################################
    # CONSTRUCTOR
    # TODO: make constructor to be able to take 3 configurations of parameters (set, ConditionalSet, DiscreteSet)
    constructor: (boundarySettings, condition, elems = []) ->
        # nothing passed => assume a domain is created
        if arguments.length is 0
            return


        if not boundarySettings?
            boundarySettings =
                leftBoundary: null
                rightBoundary: null

        @leftBoundary = boundarySettings.leftBoundary
        @rightBoundary = boundarySettings.rightBoundary

        if condition instanceof Function
            @condition = condition
        else
            @condition = null


        @_discreteSet = new mathJS.DiscreteSet()
        @_conditionalSet = new mathJS.ConditionalSet()

        for elem in elems when mathJS.isComparable elem
            # discrete set => union w/ discrete set
            if elem instanceof mathJS.DiscreteSet or elem.instanceof?(mathJS.DiscreteSet)
                @_discreteSet = @_discreteSet.union elem
            # conditional set  => union w/ conditional set
            else if elem instanceof mathJS.ConditionalSet or elem.instanceof?(mathJS.ConditionalSet)
                @_conditionalSet = @_conditionalSet.union elem
            # mathJS.Number or primitive => union w/ discrete set
            else
                @_discreteSet = @_discreteSet.union new mathJS.DiscreteSet( [elem] )

        # console.log ">>", @_discreteSet, @_conditionalSet

        Object.defineProperties @, {
            _universe:
                value: null
                enumerable: false
                writable: true
            universe:
                get: () ->
                    return @_universe
                set: (universe) ->
                    if universe instanceof mathJS.Set or universe is null
                        @_universe = universe
                    return @
                enumerable: true
            size:
                value: @_discreteSet.size + @_conditionalSet.size
                enumerable: true
                writable: false
                configurable: true # for overwriting in case of in-place union
        }

    ###########################################################################
    # PRIVATE METHODS

    ###########################################################################
    # PROTECTED METHODS

    ###########################################################################
    # PUBLIC METHODS

    clone: () ->
        # TODO
        throw new Error("todo!")
        return

    equals: (set) ->
        # TODO
        throw new Error("todo!")

    isSubsetOf: (set) ->
        # TODO
        throw new Error("todo!")

    isSupersetOf: (set) ->
        # TODO
        throw new Error("todo!")

    forAll: () ->

    exists: () ->

    contains: (elem) ->
        if elem instanceof @type
            for subset in @subsets
                if subset.contains elem
                    return true
        return false

    has: @::contains

    union: (set) ->
        # TODO: how to avoid doubles?
        # see if the set matches any already existing set
        # if @intersects set
        #     # remove duplicates from given set
        #     set = set.without @
        #     @subsets.push set
        # # disjoint sets
        # else
        #     @subsets.push set

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

    # size: () ->
    #     return @_discreteSet.size + @_conditionalSet.size

    isEmpty: () ->
        return @size is 0

    # cardinality: @::size

    # makeToDiscreteSet: () ->
    #     @.__proto__ = mathJS.DiscreteSet.prototype
    #     return @
    #
    # makeToConditionalSet: () ->
    #     @.__proto__ = mathJS.ConditionalSet.prototype
    #     return @
# end js/Set/Set.coffee

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
    constructor: (elems = []) ->
        @leftBoundary = null
        @rightBoundary = null
        @condition = null
        @elems = []

        for elem in elems when mathJS.isComparable(elem) and not @contains(elem)
            @elems.push elem

        Object.defineProperties @, {
            elems:
                value: @elems
                enumerable: false
            _universe:
                value: null
                enumerable: false
                writable: true
            universe:
                get: () ->
                    return @_universe
                set: (universe) ->
                    if universe instanceof mathJS.Set or universe is null
                        @_universe = universe
                    return @
                enumerable: true
            size:
                value: @elems.length
                enumerable: false
                writable: false
                configurable: true # for overwriting in case of in-place union
        }

    ###########################################################################
    # PROTECTED METHODS


    ###########################################################################
    # PUBLIC METHODS

    isSubsetOf: (set) ->
        for e in @elems
            if not set.contains e
                return false
        return true

    isSupersetOf: (set) ->
        return set.isSubsetOf @

    clone: () ->
        return new mathJS.DiscreteSet(@elems)

    ###*
    * @Override
    *###
    equals: (set) ->
        return @isSubsetOf(set) and set.isSubsetOf(@)

    contains: (elem) ->
        if mathJS.isComparable elem
            for e in @elems when e is elem or e.equals?(elem)
                return true
        return false

    union: (set) ->
        if set instanceof mathJS.DiscreteSet
            # console.log "here we are!", @elems.concat set.elems
            return new mathJS.DiscreteSet(@elems.concat set.elems)
        else if set instanceof mathJS.ConditionalSet
            # throw new Error("Todo!") TODO
            return "asdf"

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
# end js/Set/DiscreteSet.coffee

# from js/Set/ConditionalSet.coffee
class mathJS.ConditionalSet extends mathJS.Set

    constructor: (condition, universe = null) ->
        if condition instanceof mathJS.SetSpec
            @condition = condition
        else
            @condition = null

        @leftBoundary = null
        @rightBoundary = null

        Object.defineProperties @, {
            # elems:
            #     value: @elems
            #     enumerable: false
            _universe:
                value: universe
                enumerable: false
                writable: true
            universe:
                get: () ->
                    return @_universe
                set: (universe) ->
                    if universe instanceof mathJS.Set or universe is null
                        @_universe = universe
                    return @
                enumerable: true
            size:
                value: @elems.length
                enumerable: false
                writable: false
                configurable: true # for overwriting in case of in-place union
        }



    clone: () ->
        # TODO
        throw new Error("todo!")
        return

    equals: (set) ->
        # TODO
        throw new Error("todo!")

    isSubsetOf: (set) ->
        # TODO
        throw new Error("todo!")

    isSupersetOf: (set) ->
        # TODO
        throw new Error("todo!")

    forAll: () ->

    exists: () ->

    # addElem: (elem) ->
    #     if elem instanceof @type
    #         return @union(new mathJS.DiscreteSet(@type, elem))
    #     return @
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

    # removeElem: (elem) ->
    #     if elem instanceof @type
    #         return @without(new mathJS.DiscreteSet(@type, elem))
    #         # subset.remove elem for subset in @subsets
    #         #
    #         # elems = []
    #         # for e in @elems
    #         #     if e.equals(elem) or e is elem
    #         #         continue
    #         #     elems.push e
    #         #
    #         # @elems = elems
    #     return @

    contains: (elem) ->
        if mathJS.isComparable elem
            if @condition?.check(elem) is true
                return true
        return false

    union: (set) ->
        # TODO: how to avoid doubles?
        # see if the set matches any already existing set
        # if @intersects set
        #     # remove duplicates from given set
        #     set = set.without @
        #     @subsets.push set
        # # disjoint sets
        # else
        #     @subsets.push set

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

    # size: () ->
    #     return @_discreteSet.size + @_conditionalSet.size

    isEmpty: () ->
        return @size > 0

    cardinality: @::size
# end js/Set/ConditionalSet.coffee

# from js/Set/Domains/N.coffee
class mathJS.Sets.N extends mathJS.Set

    CLASS = @

    @new: () ->
        return new CLASS()

    constructor: () ->

        # define everything (and make things non-overwritable)
        Object.defineProperties @, {
            # PRIVATE
            # generator function.
            # generally it is a mapper from N -> X that has to be continuous and increasing
            generator:
                value: (n) ->
                    return n
                writable: false
                enumerable: false
                configurable: false
            expression:
                value: (x) ->
                    return x
                writable: false
                enumerable: false
                configurable: false
            # PROPERTIES
            # id:
            #     value: "N"
            #     enumerable: false
            #     writable: false
            #     configurable: false
            isCountable:
                value: true
                enumerable: true
                writable: false
                configurable: false
            size:
                value: Infinity
                enumerable: true
                writable: false
                configurable: false
            isMutable:
                value: false
                writable: false
                enumerable: false
                configurable: false
            leftBoundary:
                value:
                    value: -Infinity
                    open: true # implicit but listed here for clarity
                writable: false
                enumerable: false
                configurable: false
            rightBoundary:
                value:
                    value: +Infinity
                    open: true # implicit but listed here for clarity
                writable: false
                enumerable: false
                configurable: false
            # FUNCTIONS (overriding prototype)
            # contains:
            #     value: contains
            #     writable: false
            #     enumerable: true
            #     configurable: false
            # has:
            #     value: contains
            #     writable: false
            #     enumerable: true
            #     configurable: false
        }


    #################################################################################
    # STATIC


    #################################################################################
    # PUBLIC
    contains: (x) ->
        return mathJS.isInt(x) or new mathJS.Int(x).equals(x)

    clone: @new

    equals: (set, n = mathJS.settings.set.maxIterations * 10) ->
        # TODO
        # what about {x | x in R and x >= 0 and floor(x) = x} ?? should become true but how?!
        # try n steps and see if values equal. if so assume the sets equal as well
        if @_isSet set
            if set.size is Infinity
                generator = @generator
                i = 0
                while i++ < n
                    # TODO: write intervall class that extends conditionalSet and sets implicit generators
                    val = generator(i)
                    if not set.contains val
                        return false
                    if DEBUG
                        console.log "japp"
                return true
            # set is finite => can't be equal
            return false
        # set has no generator => no infinite set => is finite => can't be equal
        return false

    ###*
    * This method checks if `this` is a subset of the given set `set`. Since equality must be checked by checking an arbitrary number of values this method actually does the same as `this.equals()`. For `this.equals()` the number of compared elements is 10x bigger.
    *###
    isSubsetOf: (set, n = mathJS.settings.set.maxIterations) ->
        return @equals(set, n * 10)

    isSupersetOf: (set) ->
        if @_isSet set
            return set.isSubsetOf @
        return false

    union: (set, n = mathJS.settings.set.maxIterations, matches = mathJS.settings.set.maxMatches) ->
        # AND both checker functions
        checker = (elem) ->
            return self.checker(elem) or set.checker(elem)

        generator = () ->

        # TODO: how to avoid doubles? implementations that use boolean arrays => XOR operations on elements
        # discrete set
        if set instanceof mathJS.DiscreteSet or set.instanceof?(mathJS.DiscreteSet)

        # non-discrete set (empty or conditional set, or domain)
        else if set instanceof mathJS.Set or set.instanceof?(mathJS.Set)
            # check for domains. if set is a domain this or the set can directly be returned because they are immutable
            # N
            if mathJS.instanceof(set, mathJS.Set.N)
                return @
            # Q, R # TODO: other domains like I, C
            if mathJS.instanceof(set, mathJS.Domains.Q) or mathJS.instanceof(set, mathJS.Domains.R)
                return set


            self = @



        # param was no set
        return null

    intersect: (set) ->
        # AND both checker functions
        checker = (elem) ->
            return self.checker(elem) and set.checker(elem)

        # if the f2-invert of the y-value of f1 lies within f2' domain/universe both ranges include that value
        # or vice versa
        # we know this' generator function has N as domain (and as range of course)
        # we even know the set's generator function also has N as domain as we assume that (because the mapping is always a bijection from N -> X)
        # so we can only check a single value at a time so we have to have to boundaries for the number of iterations and the number of matches
        # after x matches we try to find a series that produces those matches (otherwise a discrete set will be created)
        commonElements = []
        x = 0 # current iteration = current x value
        m = 0 # current matches
        f1 = @generator
        f2 = set.generator
        f1Elems = [] # in ascending order because generators are increasing
        f2Elems = [] # in ascending order because generators are increasing

        while x < n and m < matches
            y1 = f1(x) # TODO: maybe inline generator function here?? but that would mean every sub class has to overwrite
            y2 = f2(x)

            # f1 is bigger than f2 at current x => check for y2 in f1Elems
            if mathJS.gt(y1, y2)
                found = false
                for f1Elem, i in f1Elems when mathJS.equals(y2, f1Elem)
                    # new match!
                    m++
                    found = true
                    # y2 found in f1Elems => add to common elements
                    commonElements.push y2
                    # because both functions are increasing dispose of earlier elements
                    # remove all unneeded elements from f1Elems incl. (current) y1
                    f1Elems = f1Elems.slice(i + 1)
                    # y2 was a match (the last in f2Elems) and y1 is bigger than y2 so we can forget everything in f2Elems
                    f2Elems = []
                    # exit loop
                    break

                if not found
                    f1Elems.push y1
                    f2Elems.push y2
            # f2 is bigger than f1 at current x => check for y1 in f2Elems
            else if mathJS.lt(y1, y2)
                found = false
                for f2Elem, i in f2Elems when mathJS.equals(y1, f2Elem)
                    # new match!
                    m++
                    found = true
                    # y1 found in f2Elems => add to common elements
                    commonElements.push y1
                    # because both functions are increasing dispose of earlier elements
                    # remove all unneeded elements from f2Elems incl. (current) y1
                    f2Elems = f2Elems.slice(i + 1)
                    # y1 was a match (the last in f2Elems) and y1 is bigger than y1 so we can forget everything in f1Elems
                    f1Elems = []
                    # exit loop
                    break

                if not found
                    f1Elems.push y1
                    f2Elems.push y2
            # equal
            else
                m++
                commonElements.push y1
                # all previous values are unimportant because in the next iteration the new values will BOTH be greater than y1=y2 and the 2 lists contain only smaller elements than y1=y2 so there can't be a match with the next elements
                f1Elems = []
                f2Elems = []
            # increment
            x++

        console.log "x=#{x}", "m=#{m}", commonElements

        # try to find formular from series (supported is: +,-,*,/)
        ops = []
        for elem in commonElements
            true


        # example: c1 = x^2, c2 = 2x+1
        # c1: 0, 1, 4, 9, 16, 25, 36, 49, 64, 81...
        # c2: 1, 3, 5, 7, 9, 11, 13, 15, 17, ...
        # => 1, 9, 25, 49, 81, 121, 169, 225, 289, 361, 441, 529, 625, 729, 841, 961, 1089, 1225, 1369, 1521, 1681, 1849
        # this is all odd squares (all odd numbers squared!) ==> f(x) = (2x + 1)^2
        # ==> slower increasing function = f, faster increasing function = g -> new-f(x) = g(f(x)) = (g o f)(x)
        # actually it is the "bigger function" with a constraint

        # inserting smaller in bigger works also for 2x, 3x
        # what about 2x, 3x+1 -> 3(2x) + 1 = 6x+1
        # but 2x, 2x => 2(2x) = 4x wrong!

        # series like   *2, +1, *3, -1, *4, +1,  *5,  -1,  *6,  +1, ...
        # would create 1, 2,  3,  9,  8, 32, 33, 165, 164, 984, 985
        # indices:     0  1   2   3   4   5   6    7    8    9   10
        # f would be y = x^2 + (-1)^x
        return

    intersects: (set) ->
        return @intersection(set).size > 0

    disjoint: (set) ->
        return @intersection(set).size is 0

    complement: () ->
        if @universe?
            return @universe.without @
        return new mathJS.EmptySet()
    ###*
    * a.without b => returns: removed all common elements from a
    *###
    without: (set) ->

    cartesianProduct: (set) ->
        # size becomes the bigger one

    times: @::cartesianProduct

    # inherited
    # isEmpty: () ->
    #     return @size is 0



# MAKE MATHJS.DOMAINS.N AN INSTANCE
do () ->
    # mathJS.Domains.N = new mathJS.Sets.N()
    Object.defineProperties mathJS.Domains, {
        N:
            value: new mathJS.Sets.N()
            writable: false
            enumerable: true
            configurable: false
    }
# end js/Set/Domains/N.coffee

# from js/Function.coffee
class mathJS.Function extends mathJS.ConditionalSet

    constructor: (fromSet, toSet, mapping) ->
        @fromSet = fromSet
        @toSet = toSet
        @mapping = mapping
# end js/Function.coffee

# from js/Calculus/Integral.coffee
class mathJS.Integral

    CLASS = @

    if DEBUG
        @test = () ->
            i = new mathJS.Integral(
                (x) ->
                    return -2*x*x-3*x+10
                -3
                1
            )
            start = Date.now()
            console.log i.solve(false, 0.00000000000001), Date.now() - start
            start = Date.now()
            i.solveAsync(
                (res) ->
                    console.log res, "async took:", Date.now() - start
                false
                0.0000001
            )
            start2 = Date.now()
            console.log i.solve(), Date.now() - start2

            return "test done"

    constructor: (integrand, leftBoundary=-Infinity, rightBoundary=Infinity, integrationVariable=new mathJS.Variable("x")) ->
        @integrand = integrand
        @leftBoundary = leftBoundary
        @rightBoundary = rightBoundary
        @integrationVariable = integrationVariable

        @settings = null

    # PRIVATE
    _solvePrepareVars = (from, to, abs, stepSize) ->
        # absolute integral?
        if abs is false
            modVal = mathJS.id
        else
            modVal = (x) ->
                return Math.abs(x)

        # get primitives
        from = from.value or from
        to = to.value or to

        # swap if in wrong order
        if to < from
            tmp = to
            to = from
            from = tmp

        if (diff = to - from) < stepSize
            # stepSize = diff * stepSize * 0.1
            stepSize = diff * 0.001

        return {
            modVal: modVal
            from: from
            to: to
            stepSize: stepSize
        }

    # STATIC
    @solve = (integrand, from, to, abs=false, stepSize=0.01, settings={}) ->
        vars = _solvePrepareVars(from, to, abs, stepSize)

        modVal = vars.modVal
        from = vars.from
        to = vars.to
        stepSize = vars.stepSize

        if (steps = (to - from) / stepSize) > settings.maxSteps or mathJS.settings.integral.maxSteps
            throw new mathJS.Errors.CalculationExceedanceError("Too many calculations (#{steps.toExponential()}) ahead! Either adjust mathJS.Integral.settings.maxSteps, set the Integral's instance's settings or pass settings to mathJS.Integral.solve() if you really need that many calculations.")

        res = 0

        # cache 0.5 * stepSize
        halfStepSize = 0.5 * stepSize

        y1 = integrand(from)
        if DEBUG
            i = 0
        for x2 in [(from + stepSize)..to] by stepSize
            if DEBUG
                i++
            y2 = integrand(x2)

            if mathJS.sign(y1) is mathJS.sign(y2)
                # trapezoid formula
                res += modVal((y1 + y2) * halfStepSize)
            # else: round to zero -> no calculation needed

            y1 = y2

        if DEBUG
            console.log "made", i, "calculations"

        return res

    ###*
    * For better calculation performance of the integral decrease delay and numBlocks.
    * For better overall performance increase them.
    * @public
    * @static
    * @method solveAsync
    * @param integrand {Function}
    * @param from {Number}
    * @param to {Number}
    * @param callback {Function}
    * @param abs {Boolean}
    * Optional. Indicates whether areas below the graph are negative or not.
    * Default is false.
    * @param stepSize {Number}
    * Optional. Defines the width of each trapezoid. Default is 0.01.
    * @param delay {Number}
    * Optional. Defines the time to pass between blocks of calculations.
    * Default is 2ms.
    * @param numBlocks {Number}
    * Optional. Defines the number of calculation blocks.
    * Default is 100.
    *###
    @solveAsync: (integrand, from, to, callback, abs, stepSize, delay=2, numBlocks=100) ->
        if not callback?
            return false

        # split calculation into numBlocks blocks
        blockSize = (to - from) / numBlocks
        block = 0

        res = 0

        f = (from, to) ->
            # done with all blocks => return result to callback
            if block++ is numBlocks
                return callback(res)

            res += CLASS.solve(integrand, from, to, abs, stepSize)

            setTimeout  () ->
                            f(to, to + blockSize)
                        , delay

            return true

        f(from, from + blockSize)

        return @

    # PUBLIC
    solve: (abs, stepSize) ->
        return CLASS.solve(@integrand, @leftBoundary, @rightBoundary, abs, stepSize)

    solveAsync: (callback, abs, stepSize) ->
        return CLASS.solveAsync(@integrand, @leftBoundary, @rightBoundary, callback, abs, stepSize)
# end js/Calculus/Integral.coffee

# from js/LinearAlgebra/Vector.coffee
class mathJS.Vector

    _isVectorLike: (v) ->
        return v instanceof mathJS.Vector or v.instanceof?(mathJS.Vector) or v instanceof mathJS.Tuple or v.instanceof?(mathJS.Tuple)

    @_isVectorLike: @::_isVectorLike

    # CONSTRUCTOR
    constructor: (values) ->
        # check values for
        @values = values
        if DEBUG
            for val in values when not mathJS.isMathJSNum(val)
                console.warn "invalid value:", val

    equals: (v) ->
        if not @_isVectorLike(v)
            return false

        for val, i in @values
            vValue = v.values[i]
            if not val.equals?(vValue) and val isnt vValue
                return false
        return true

    clone: () ->
        return new TD.Vector(@values)

    move: (v) ->
        if not @_isVectorLike v
            return @

        for val, i in v.values
            vValue = v.values[i]
            @values[i] = vValue.plus?(val) or val.plus?(vValue) or (vValue + val)

        return @

    moveBy: @move

    moveTo: (p) ->
        if not @_isVectorLike v
            return @

        for val, i in v.values
            vValue = v.values[i]
            @values[i] = vValue.value or vValue
        return @

    multiply: (r) ->
        if Math.isNum r
            return new TD.Point(@x * r, @y * r)
        return null

    # make alias
    times: @multiply

    magnitude: () ->
        sum = 0
        for val, i in @values
            sum += val * val

        return Math.sqrt(sum)

    ###*
     * This method calculates the distance between 2 points.
     * It's a shortcut for substracting 2 vectors and getting that vector's magnitude (because no new object is created).
     * For that reason this method should be used for pure distance calculations.
     *
     * @method distanceTo
     * @param {Point} p
     * @return {Number} Distance between this point and p.
    *###
    distanceTo: (v) ->
        sum = 0

        for val, i in @values
            sum += (val - v.values[i]) * (val - v.values[i])

        return Math.sqrt(sum)

    add: (v) ->
        if not @_isVectorLike v
            return null

        values = []
        for val, i in v.values
            vValue = v.values[i]
            values.push(vValue.plus?(val) or val.plus?(vValue) or (vValue + val))

        return new mathJS.Vector(values)

    # make alias
    plus: @add

    substract: (p) ->
        if isPointLike p
            return new TD.Point(@x - p.x, @y - p.y)
        return null

    # make alias
    minus: @substract

    xyRatio: () ->
        return @x / @y

    toArray: () ->
        return [@x, @y]

    isPositive: () ->
        return @x >= 0 and @y >= 0

    ###*
     * Returns the angle of a vector. Beware that the angle is measured in counter clockwise direction beginning at 0˚ which equals the x axis in positive direction.
     * So on a computer grid the angle won't be what you expect! Use anglePC() in that case!
     *
     * @method angle
     * @return {Number} Angle of the vector in degrees. 0 degrees means pointing to the right.
    *###
    angle: () ->
        # 1st quadrant (and zero)
        if @x >= 0 and @y >= 0
            return Math.radToDeg( Math.atan( Math.abs(@y) / Math.abs(@x) ) ) % 360
        # 2nd quadrant
        if @x < 0 and @y > 0
            return (90 + Math.radToDeg( Math.atan( Math.abs(@x) / Math.abs(@y) ) )) % 360
        # 3rd quadrant
        if @x < 0 and @y < 0
            return (180 + Math.radToDeg( Math.atan( Math.abs(@y) / Math.abs(@x) ) )) % 360
        # 4th quadrant
        return (270 + Math.radToDeg( Math.atan( Math.abs(@x) / Math.abs(@y) ) )) % 360

    ###*
     * Returns the angle of a vector. 0˚ means pointing to the top. Clockwise.
     *
     * @method anglePC
     * @return {Number} Angle of the vector in degrees. 0 degrees means pointing to the right.
    *###
    anglePC: () ->
        # 1st quadrant: pointing to bottom right
        if @x >= 0 and @y >= 0
            return (90 + Math.radToDeg( Math.atan( Math.abs(@y) / Math.abs(@x) ) )) % 360
        # 2nd quadrant: pointing to bottom left
        if @x < 0 and @y > 0
            return (180 + Math.radToDeg( Math.atan( Math.abs(@x) / Math.abs(@y) ) )) % 360
        # 3rd quadrant: pointing to top left
        if @x < 0 and @y < 0
            return (270 + Math.radToDeg( Math.atan( Math.abs(@y) / Math.abs(@x) ) )) % 360
        # 4th quadrant: pointing to top right
        return Math.radToDeg(Math.atan( Math.abs(@x) / Math.abs(@y) ) ) % 360

    ###*
     * Returns a random Point within a given radius.
     *
     * @method randPointInRadius
     * @param {Number} radius
     * Default is 10 (pixels). Must not be smaller than 0.
     * @param {Boolean} random
     * Indicates whether the given radius is the maximum or exact distance between the 2 points.
     * @return {Number} Random Point.
    *###
    randPointInRadius: (radius = 5, random = false) ->
        angle        = Math.degToRad(Math.randNum(0, 360))
        if random is true
            radius    = Math.randNum(0, radius)

        x = radius * Math.cos angle
        y = radius * Math.sin angle

        return @add( new TD.Point(x, y) )



# same as vector with own prototype
class mathJS.Tuple extends mathJS.Vector
# end js/LinearAlgebra/Vector.coffee

# from js/start.coffee
$(document).ready () ->
    # window.g = new TD.Game()
    console.log "dom ready"
# end js/start.coffee

