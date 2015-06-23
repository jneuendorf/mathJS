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
    Utils: {}

# Take namespaces from mathJS
_mathJS = $.extend {}, mathJS

if DEBUG
    window._mathJS = _mathJS
    startTime = Date.now()
# end js/init.coffee

# from js/prototyping.coffee
# TODO: use object.defineProperties in order to hide methods from enumeration
####################################################################################
Array::reverseCopy = () ->
    res = []
    res.push(item) for item in @ by -1
    return res

Array::unique = () ->
    res = []
    for elem in @ when elem not in res
        res.push elem
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
        elem = arr.sample(1)
        res.push elem
        arr.remove elem

    return res

Array::shuffle = () ->
    arr = @sample(@length)
    for elem, i in arr
        @[i] = elem
    return @

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
# TODO: from http://jsperf.com/array-prototype-slice-call-vs-slice-call/17
# function nonnative_slice(item, start){
#   start = ~~start;
#   var
#     len = item.length, i, newArray;
#
#   newArray = new Array(len - start);
#
#   for (i = start; i < len; i++){
#     newArray[i - start] = item[i];
#   }
#
#   return newArray;
# }

Array::indexOfNative = Array::indexOf

Array::indexOf = (elem, fromIdx) ->
    idx = if fromIdx? then fromIdx else 0
    len = @length

    while idx < len
        if @[idx] is elem
            return idx
        idx++
    return -1

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
    second:
        get: () ->
            return @[1]
        set: (val) ->
            @[1] = val
            return @
    third:
        get: () ->
            return @[2]
        set: (val) ->
            @[2] = val
            return @
    fourth:
        get: () ->
            return @[3]
        set: (val) ->
            @[3] = val
            return @
    last:
        get: () ->
            return @[@length - 1]
        set: (val) ->
            @[@length - 1] = val
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


####################################################################################
# STRING
String::camel = (spaces) ->
    if not spaces?
        spaces = false

    str = @toLowerCase()
    if spaces
        str = str.split(" ")
        for i in [1...str.length]
            str[i] = str[i].charAt(0).toUpperCase() + str[i].substring(1)
        str = str.join("")

    return str

String::antiCamel = () ->
    res = @charAt(0)

    for i in [1...@length]
        temp = @charAt(i)
        # it is a capital letter -> insert space
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

String::lower = String::toLowerCase
String::upper = String::toUpperCase

# convenient index getters and setters
Object.defineProperties String::, {
    first:
        get: () ->
            return @[0]
        set: (val) ->
            return @
    second:
        get: () ->
            return @[1]
        set: (val) ->
            return @
    third:
        get: () ->
            return @[2]
        set: (val) ->
            return @
    fourth:
        get: () ->
            return @[3]
        set: (val) ->
            return @
    last:
        get: () ->
            return @[@length - 1]
        set: (val) ->
            return @
}

# implement comparable and orderable interface for primitives
String::equals = (str) ->
    return @valueOf() is str.valueOf()

String::lessThan = (str) ->
    return @valueOf() < str.valueOf()

String::lt = String::lessThan

String::greaterThan = (str) ->
    return @valueOf() > str.valueOf()

String::gt = String::greaterThan

String::lessThanOrEqualTo = (str) ->
    return @valueOf() <= str.valueOf()

String::lte = String::lessThanOrEqualTo

String::greaterThanOrEqualTo = (str) ->
    return @valueOf() >= str.valueOf()

String::gte

####################################################################################
# BOOLEAN
Boolean::equals = (bool) ->
    return @valueOf() is bool.valueOf()

Boolean::lessThan = (bool) ->
    return @valueOf() < bool.valueOf()

Boolean::lt = Boolean::lessThan

Boolean::greaterThan = (bool) ->
    return @valueOf() > bool.valueOf()

Boolean::gt = Boolean::greaterThan

Boolean::lessThanOrEqualTo = (bool) ->
    return @valueOf() <= bool.valueOf()

Boolean::lte = Boolean::lessThanOrEqualTo

Boolean::greaterThanOrEqualTo = (bool) ->
    return @valueOf() >= str.valueOf()

Boolean::gte

####################################################################################
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
        value: Number.EPSILON or 2.220446049250313e-16 # 2.220446049250313080847263336181640625e-16
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

# mathJS.instanceof = (instance, clss) ->
#     return instance instanceof clss or instance.instanceof?(clss)

# mathJS.isA = () ->

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
    # if min > max
    #     temp = min
    #     min = max
    #     max = temp
    # return Math.floor(Math.random() * (max + 1 - min)) + min
    return ~~mathJS.randNum(max, min)

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

mathJS.min = (elems...) ->
    if elems.first instanceof Array
        elems = elems.first
        propGetter = null
    else if elems.first instanceof Function
        propGetter = elems.first
        elems = elems.slice(1)
        if elems.first instanceof Array
            elems = elems.first

    res = []
    min = null
    for item in elems
        if propGetter?
            item = propGetter(item)

        if min is null or item.lessThan(min) or item < min
            min = item
            res = [elem]
        # same as min found => add to list
        else if item.equals(min) or item is min
            res.push elem

    return res

mathJS.max = (elems...) ->
    if elems.first instanceof Array
        elems = elems.first
        propGetter = null
    else if elems.first instanceof Function
        propGetter = elems.first
        elems = elems.slice(1)
        if elems.first instanceof Array
            elems = elems.first

    res = []
    max = null
    for item in elems
        if propGetter?
            item = propGetter(item)

        if max is null or item.greaterThan(max) or item > max
            max = item
            res = [elem]
        # same as max found => add to list
        else if item.equals(max) or item is max
            res.push elem

    return res

mathJS.log = (n, base = 10) ->
    return Math.log(n) / Math.log(base)

mathJS.logBase = mathJS.log

mathJS.reciprocal = (n) ->
    if mathJS.isNum(n)
        return 1 / n
    return NaN

mathJS.sortFunction = (a, b) ->
    if a.lessThan b
        return -1
    if a.greaterThan b
        return 1
    return 0
# end js/mathJS.coffee

# from js/settings.coffee
mathJS.settings =
    generator:
        maxIndex: 1e4
    integral:
        maxSteps: 1e10
    # maxPoolSize is for EACH pool
    maxPoolSize: 100
    number:
        real:
            distance: 1e-6
    set:
        defaultNumberOfElements: 1e3
        maxIterations: 1e3
        maxMatches: 60


mathJS.config = mathJS.settings
# end js/settings.coffee

# from js/mathJSObject.coffee
###*
* This is the super class of all mathJS classes.
* Therefore all cross-class things are defined here.
* @class Object
*###
class _mathJS.Object

    @_implements    = []
    @_implementedBy = []

    @implements = (classes...) ->
        if classes.first instanceof Array
            classes = classes.first

        for clss in classes
            # make the class / interface know what classes implement it
            if @ not in clss._implementedBy
                clss._implementedBy.push @

            # implement class / interface
            clssPrototype = clss.prototype
            # "window." necessary because coffee creates an "Object" variable for this class
            prototypeKeys = window.Object.keys(clssPrototype)
            # static
            for name, method of clss when name not in prototypeKeys
                @[name] = method
            # non-static (from prototype)
            for name, method of clssPrototype
                @::[name] = method
            @_implements.push clss

        return @

    isA: (clss) ->
        if not clss? or clss not instanceof Function
            return false

        if @ instanceof clss
            return true

        for c in @constructor._implements
            # direct hit
            if c is clss
                return true

            # check super classes ("__superClass__" is set when coffee extends classes using macros...see macros.js)
            while (c = c.__superClass__)?
                if c is clss
                    return true

        return false

    instanceof: () ->
        return @isA.apply(@, arguments)
# end js/mathJSObject.coffee

# from js/Errors/SimpleErrors.coffee
# class _mathJS.Errors.Error extends window.Error
#
#     constructor: (message, fileName, lineNumber, misc...) ->
#         super(message, fileName, lineNumber)
#         @misc = misc
#
#     toString: () ->
#         return "#{super()}\n more data: #{@misc.toString()}"

class mathJS.Errors.CalculationExceedanceError extends Error

class mathJS.Errors.InvalidVariableError extends Error

class mathJS.Errors.InvalidParametersError extends Error

class mathJS.Errors.InvalidArityError extends Error

class mathJS.Errors.NotImplementedError extends Error

class mathJS.Errors.CycleDetectedError extends Error
# end js/Errors/SimpleErrors.coffee

# from js/Utils/Hash.coffee
###*
 * This is an implementation of a dictionary/hash that does not convert its keys into Strings. Keys can therefore actually by anything!
 * @class Hash
 * @constructor
*###
class mathJS.Utils.Hash

    ###*
     * Creates a new Hash from a given JavaScript object.
     * @static
     * @method fromObject
     * @param object {Object}
    *###
    @fromObject: (obj) ->
        return new mathJS.Utils.Hash(obj)

    @new: (obj) ->
        return new mathJS.Utils.Hash(obj)

    constructor: (obj) ->
        @keys   = []
        @values = []

        if obj?
            @put key, val for key, val of obj

    clone: () ->
        res         = new mathJS.Utils.Hash()
        res.keys    = @keys.clone()
        res.values  = @values.clone()
        return res

    invert: () ->
        res         = new mathJS.Utils.Hash()
        res.keys    = @values.clone()
        res.values  = @keys.clone()
        return res

    ###*
     * Adds a new key-value pair or overwrites an existing one.
     * @method put
     * @param key {mixed}
     * @param val {mixed}
     * @return {Hash} This instance.
     * @chainable
    *###
    put: (key, val) ->
        idx = @keys.indexOf key
        # add new entry
        if idx < 0
            @keys.push key
            @values.push val
        # overwrite entry
        else
            @keys[idx] = key
            @values[idx] = val

        return @

    ###*
     * Returns the value (or null) for the specified key.
     * @method get
     * @param key {mixed}
     * @param [equalityFunction] {Function}
     * This optional function can overwrite the test for equality between keys. This function expects the parameters: (the current key in the key iteration, 'key'). If this parameters is omitted '===' is used.
     * @return {mixed}
    *###
    get: (key) ->
        if (idx = @keys.indexOf(key)) >= 0
            return @values[idx]
        return null

    ###*
     * Indicates whether the Hash has the specified key.
     * @method hasKey
     * @param key {mixed}
     * @return {Boolean}
    *###
    hasKey: (key) ->
        return key in @keys

    has: (key) ->
        return @hasKey(key)

    ###*
     * Returns the number of entries in the Hash.
     * @method size
     * @return {Integer}
    *###
    size: () ->
        return @keys.length

    empty: () ->
        @keys   = []
        @values = []
        return @

    remove: (key) ->
        if (idx = @keys.indexOf(key)) >= 0
            @keys.splice idx, 1
            @values.splice idx, 1
        else
            console.warn "Could not remove key '#{key}'!"
        return @

    each: (callback) ->
        for key, i in @keys when callback(key, @values[i], i) is false
            return @
        return @
# end js/Utils/Hash.coffee

# from js/Utils/Dispatcher.coffee
class mathJS.Utils.Dispatcher extends _mathJS.Object

    @registeredDispatchers = mathJS.Utils.Hash.new()

    # try to detect cyclic dispatching
    @registerDispatcher: (newReceiver, newTargets) ->
        registrationPossible = true

        regReceivers = @registeredDispatchers.keys
        @registeredDispatchers.each (regReceiver, regTargets, idx) ->
            for regTarget in regTargets when regTarget is newReceiver
                for newTarget in newTargets when regReceivers.indexOf(newTarget)
                    registrationPossible = false
                    return false
            return true

        if registrationPossible
            @registeredDispatchers.put(newReceiver, newTargets)
            return @

        throw new mathJS.Errors.CycleDetectedError("Can't register '#{newReceiver}' for dispatching - cycle detected!")

    # CONSTRUCTOR
    constructor: (receiver, targets=[]) ->
        @constructor.registerDispatcher(receiver, targets)

        @receiver = receiver
        @targets = targets

    # needsDispatching: (target) ->
    #     return (target.constructor or target) in @targets

    dispatch: (target, method, params...) ->
        dispatch = false
        # check instanceof and identity
        if @targets.indexOf(target.constructor or target) >= 0
            dispatch = true
        # check typeof (for primitives)
        else
            for t in @targets when typeof target is t
                dispatch = true
                break

        if dispatch
            if target[method] instanceof Function
                return target[method].apply(target, params)
            throw new mathJS.Errors.NotImplementedError(
                "Can't call '#{method}' on target '#{target}'"
                "Dispatcher.coffee"
                undefined
                target
            )

        return null
# end js/Utils/Dispatcher.coffee

# from js/Interfaces/Interface.coffee
class _mathJS.Interface extends _mathJS.Object
    @implementedBy = []

    @isImplementedBy = () ->
        return @implementedBy
# end js/Interfaces/Interface.coffee

# from js/Interfaces/Comparable.coffee
class _mathJS.Comparable extends _mathJS.Interface

    ###*
    * This method checks for mathmatical equality. This means new mathJS.Double(4.2).equals(4.2) is true.
    * @method equals
    * @param {Number} n
    * @return {Boolean}
    *###
    equals: (n) ->
        throw new mathJS.Errors.NotImplementedError("equals in #{@contructor.name}")

    e: () ->
        return @equals.apply(@, arguments)
# end js/Interfaces/Comparable.coffee

# from js/Interfaces/Orderable.coffee
class _mathJS.Orderable extends _mathJS.Comparable

    ###*
    * This method checks for mathmatical "<". This means new mathJS.Double(4.2).lessThan(5.2) is true.
    * @method lessThan
    * @param {Number} n
    * @return {Boolean}
    *###
    lessThan: (n) ->
        throw new mathJS.Errors.NotImplementedError("lessThan in #{@contructor.name}")

    ###*
    * Alias for `lessThan`.
    * @method lt
    *###
    lt: () ->
        return @lessThan.apply(@, arguments)

    ###*
    * This method checks for mathmatical ">". This means new mathJS.Double(4.2).greaterThan(3.2) is true.
    * @method greaterThan
    * @param {Number} n
    * @return {Boolean}
    *###
    greaterThan: (n) ->
        throw new mathJS.Errors.NotImplementedError("greaterThan in #{@contructor.name}")

    ###*
    * Alias for `greaterThan`.
    * @method gt
    *###
    gt: () ->
        return @greaterThan.apply(@, arguments)

    ###*
    * This method checks for mathmatical "<=". This means new mathJS.Double(4.2).lessThanOrEqualTo(5.2) is true.
    * @method lessThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *###
    lessThanOrEqualTo: (n) ->
        throw new mathJS.Errors.NotImplementedError("lessThanOrEqualTo in #{@contructor.name}")

    ###*
    * Alias for `lessThanOrEqualTo`.
    * @method lte
    *###
    lte: () ->
        return @lessThanOrEqualTo.apply(@, arguments)

    ###*
    * This method checks for mathmatical ">=". This means new mathJS.Double(4.2).greaterThanOrEqualTo(3.2) is true.
    * @method greaterThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *###
    greaterThanOrEqualTo: (n) ->
        throw new mathJS.Errors.NotImplementedError("greaterThanOrEqualTo in #{@contructor.name}")

    ###*
    * Alias for `greaterThanOrEqualTo`.
    * @method gte
    *###
    gte: () ->
        return @greaterThanOrEqualTo.apply(@, arguments)
# end js/Interfaces/Orderable.coffee

# from js/Interfaces/Parseable.coffee
class _mathJS.Parseable extends _mathJS.Interface

    @parse: (str) ->
        throw new mathJS.Errors.NotImplementedError("static parse in #{@name}")

    @fromString: (str) ->
        return @parse(str)

    toString: (args) ->
        throw new mathJS.Errors.NotImplementedError("toString in #{@contructor.name}")
# end js/Interfaces/Parseable.coffee

# from js/Interfaces/Poolable.coffee
class _mathJS.Poolable extends _mathJS.Interface

    @_pool = []

    @_fromPool: () ->
        # implementation should be something like:
        # if @_pool.length > 0
        #     return @_pool.pop()
        # return new @()
        throw new mathJS.Errors.NotImplementedError("static _fromPool in #{@name}")

    ###*
    * Releases the instance to the pool of its class.
    * @method release
    * @return This intance
    * @chainable
    *###
    release: () ->
        if @constructor._pool.length < mathJS.settings.maxPoolSize
            @constructor._pool.push @
        if DEBUG
            if @constructor._pool.length >= mathJS.settings.maxPoolSize
                console.warn "#{@constructor.name}-pool is full:", @constructor._pool
        return @
# end js/Interfaces/Poolable.coffee

# from js/Interfaces/Evaluable.coffee
class _mathJS.Evaluable extends _mathJS.Interface

    eval: () ->
        throw new mathJS.Errors.NotImplementedError("eval() in #{@contructor.name}")
# end js/Interfaces/Evaluable.coffee

# from js/Numbers/AbstractNumber.coffee
# This file defines the Number interface.
class _mathJS.AbstractNumber extends _mathJS.Object

    @implements _mathJS.Orderable, _mathJS.Poolable, _mathJS.Parseable

    ###*
    * @Override mathJS.Poolable
    * @static
    * @method _fromPool
    *###
    @_fromPool: (value) ->
        if @_pool.length > 0
            if (val = @_getPrimitive(value))?
                number = @_pool.pop()
                number.value = val.value or val
                return number
            throw new mathJS.Errors.InvalidParametersError(
                "Can't instatiate number from given '#{value}'"
                "AbstractNumber.coffee"
                undefined
                value
            )
        # param check is done in constructor
        return new @(value)

    ###*
    * @Override mathJS.Parseable
    * @static
    * @method parse
    *###
    @parse: (str) ->
        return @_fromPool parseFloat(str)

    @getSet: () ->
        throw new mathJS.Errors.NotImplementedError("getSet in #{@name}")

    @new: (param) ->
        return @_fromPool param

    @random: (max, min) ->
        return @_fromPool mathJS.randNum(max, min)

    @dispatcher = new mathJS.Utils.Dispatcher(@, [
        # mathJS.Matrix
        "string"
    ])

    ###*
    * This method is used to parse and check a parameter.
    * Either a valid value is returned or null (for invalid parameters).
    * @static
    * @method _getPrimitive
    * @param param {Object}
    * @param skipCheck {Boolean}
    * @return {mathJS.Number}
    *###
    @_getPrimitive: (param, skipCheck) ->
        return null

    ############################################################################################
    # PROTECTED METHODS
    _setValue: (value) ->
        # if (val = @_getPrimitive(value))?
        #     @_value = val
        return @

    _getValue: () ->
        return @_value

    _getPrimitive: (param) ->
        return @constructor._getPrimitive(param)

    ############################################################################################
    # PUBLIC METHODS

    ############################################################################################
    # COMPARABLE INTERFACE
    ###*
    * @Override mathJS.Comparable
    * This method checks for mathmatical equality. This means new mathJS.Double(4.2).equals(4.2) is true.
    * @method equals
    * @param {Number} n
    * @return {Boolean}
    *###
    equals: (n) ->
        if (val = @_getPrimitive(n))?
            return @value is val
        return false

    ###*
    * @Override mathJS.Orderable
    * This method checks for mathmatical "<". This means new mathJS.Double(4.2).lessThan(5.2) is true.
    * @method lessThan
    *###
    lessThan: (n) ->
        if (val = @_getPrimitive(n))?
            return @value < val
        return false

    ###*
    * @Override mathJS.Orderable
    * This method checks for mathmatical ">". This means new mathJS.Double(4.2).greaterThan(3.2) is true.
    * @method greaterThan
    * @param {Number} n
    * @return {Boolean}
    *###
    greaterThan: (n) ->
        if (val = @_getPrimitive(n))?
            return @value > val
        return false

    ###*
    * @Override mathJS.Orderable
    * This method checks for mathmatical "<=".
    * @method lessThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *###
    lessThanOrEqualTo: (n) ->
        return @lessThan(n) or @equals(n)

    ###*
    * This method checks for mathmatical ">=".
    * @method greaterThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *###
    greaterThanOrEqualTo: (n) ->
        return @greaterThan(n) or @equals(n)
    # END - IMPLEMENTING COMPARABLE
    ############################################################################################

    ###*
    * This method adds 2 numbers and returns a new one.
    * @method plus
    * @param {Number} n
    * @return {mathJS.Number} Calculated Number.
    *###
    plus: (n) ->
        if (val = @_getPrimitive(n))?
            return mathJS.Number.new(@value + val)

        throw new mathJS.Errors.InvalidParametersError(
            "Can't instatiate number from given '#{n}'"
            "AbstractNumber.coffee"
            undefined
            n
        )

    ###*
    * This method substracts 2 numbers and returns a new one.
    * @method minus
    * @param {Number} n
    * @return {mathJS.Number} Calculated Number.
    *###
    minus: (n) ->
        if (val = @_getPrimitive(n))?
            return mathJS.Number.new(@value - val)

        throw new mathJS.Errors.InvalidParametersError(
            "Can't instatiate number from given '#{n}'"
            "AbstractNumber.coffee"
            undefined
            n
        )

    ###*
    * This method multiplies 2 numbers and returns a new one.
    * @method times
    * @param {Number} n
    * @return {mathJS.Number} Calculated Number.
    *###
    times: (n) ->
        if (result = @constructor.dispatcher.dispatch(n, "times", @))?
            return result


        if (val = @_getPrimitive(n))?
            return mathJS.Number.new(@value * val)

        throw new mathJS.Errors.InvalidParametersError(
            "Can't instatiate number from given '#{n}'"
            "AbstractNumber.coffee"
            undefined
            n
        )

    ###*
    * This method divides 2 numbers and returns a new one.
    * @method divide
    * @param {Number} n
    * @return {Number} Calculated Number.
    *###
    divide: (n) ->
        if (val = @_getPrimitive(n))?
            return mathJS.Number.new(@value / val)

        throw new mathJS.Errors.InvalidParametersError(
            "Can't instatiate number from given '#{n}'"
            "AbstractNumber.coffee"
            undefined
            n
        )

    ###*
    * This method squares this instance and returns a new one.
    * @method square
    * @return {Number} Calculated Number.
    *###
    square: () ->
        return mathJS.Number.new(@value * @value)

    ###*
    * This method cubes this instance and returns a new one.
    * @method cube
    * @return {Number} Calculated Number.
    *###
    cube: () ->
        return mathJS.Number.new(@value * @value * @value)

    ###*
    * This method calculates the square root of this instance and returns a new one.
    * @method sqrt
    * @return {Number} Calculated Number.
    *###
    sqrt: () ->
        return mathJS.Number.new(mathJS.sqrt(@value))

    ###*
    * This method calculates the cubic root of this instance and returns a new one.
    * @method curt
    * @return {Number} Calculated Number.
    *###
    curt: () ->
        return @pow(0.3333333333333333)

    ###*
    * This method calculates any root of this instance and returns a new one.
    * @method root
    * @param {Number} exponent
    * @return {Number} Calculated Number.
    *###
    root: (exp) ->
        if (val = @_getPrimitive(exp))?
            return @pow(1 / val)

        throw new mathJS.Errors.InvalidParametersError(
            "Can't instatiate number from given '#{exp}'"
            "AbstractNumber.coffee"
            undefined
            exp
        )

    ###*
    * This method returns the reciprocal (1/n) of this number.
    * @method reciprocal
    * @return {Number} Calculated Number.
    *###
    reciprocal: () ->
        return mathJS.Number.new(1 / @value)

    ###*
    * This method returns this' value the the n-th power (this^n).
    * @method pow
    * @param {Number} n
    * @return {Number} Calculated Number.
    *###
    pow: (n) ->
        if (val = @_getPrimitive(n))?
            return mathJS.Number.new(mathJS.pow(@value, val))

        throw new mathJS.Errors.InvalidParametersError(
            "Can't instatiate number from given '#{n}'"
            "AbstractNumber.coffee"
            undefined
            n
        )

    ###*
    * This method returns the sign of this number (sign(this)).
    * @method sign
    * @param plain {Boolean}
    * Indicates whether the return value is wrapped in a mathJS.Number or not (-> primitive value).
    * @return {Number|mathJS.Number}
    *###
    sign: (plain=true) ->
        val = @value
        if plain is true
            if val < 0
                return -1
            return 1
        # else:
        if val < 0
            return mathJS.Number.new(-1)
        return mathJS.Number.new(1)

    negate: () ->
        return mathJS.Number.new(-@value)

    toInt: () ->
        return mathJS.Int.new(@value)

    toNumber: () ->
        return mathJS.Number.new(@value)

    toString: (format) ->
        if not format?
            return "#{@value}"
        return numeral(@value).format(format)

    clone: () ->
        return mathJS.Number.new(@value)

    # EVALUABLE INTERFACE
    eval: (values) ->
        return @

    _getSet: () ->
        return new mathJS.Set(@)

    ############################################################################################
    # SETS...
    in: (set) ->
        return set.contains(@)
# end js/Numbers/AbstractNumber.coffee

# from js/Numbers/Number.coffee
# TODO: mathJS.Number should also somehow be a mathJS.Expression!!!
###*
 * @abstract
 * @class Number
 * @constructor
 * @param {Number} value
 * @extends Object
*###
# TODO: make number extend expression
# class mathJS.Number extends mixOf mathJS.Orderable, mathJS.Poolable, mathJS.Parseable
class mathJS.Number extends _mathJS.AbstractNumber
    ###########################################################################################
    # STATIC
    @_getPrimitive: (param, skipCheck) ->
        if skipCheck is true
            return param

        if param instanceof mathJS.Number
            return param.value

        if param instanceof Number
            return param.valueOf()

        if mathJS.isNum(param)
            return param

        return null

    # ###*
    # * @Override mathJS.Poolable
    # * @static
    # * @method _fromPool
    # *###
    # @_fromPool: (val) ->
    #     if @_pool.length > 0
    #         if @valueIsValid val
    #             number = @_pool.pop()
    #             number.value = val.value or val
    #             return number
    #         return null
    #     else
    #         # param check is done in constructor
    #         return new @(val)

    # ###*
    # * @Override mathJS.Parseable
    # * @static
    # * @method parse
    # *###
    # @parse: (str) ->
    #     if mathJS.isNum(parsed = parseFloat(str))
    #         return @_fromPool parsed
    #     return parsed

    # @random: (max, min) ->
    #     return @_fromPool mathJS.randNum(max, min)

    # @toNumber: (n) ->
    #     if n instanceof mathJS.Number
    #         return n
    #     return new mathJS.Number(n)

    @getSet: () ->
        return mathJS.Domains.R

    # moved to AbstractNumber
    # @new: (value) ->
    #     return @_fromPool value

    ###########################################################################################
    # CONSTRUCTOR
    constructor: (value) ->
        @_value = null

        Object.defineProperties @, {
            value:
                get: @_getValue
                set: @_setValue
        }

        if (val = @_getPrimitive(value))?
            @_value = val
        else
            throw new mathJS.Errors.InvalidParametersError(
                "Can't instatiate number from given '#{value}'"
                "Number.coffee"
                undefined
                value
            )

    ###########################################################################################
    # PRIVATE METHODS

    ###########################################################################################
    # PROTECTED METHODS

    ###########################################################################################
    # PUBLIC METHODS

    ########################################################
    # IMPLEMENTING COMPARABLE
    # see AbstractNumber
    # END - IMPLEMENTING COMPARABLE

    ########################################################
    # IMPLEMENTING BASIC OPERATIONS
    # see AbstractNumber
    # END - IMPLEMENTING BASIC OPERATIONS

    # EVALUABLE INTERFACE
    eval: (values) ->
        return @

    # TODO: intercept destructor
    # .....

    _getSet: () ->
        return new mathJS.Set(@)

    in: (set) ->
        return set.contains(@)

    valueOf: @::_getValue
# end js/Numbers/Number.coffee

# from js/Numbers/Double.coffee
class mathJS.Double extends mathJS.Number
# end js/Numbers/Double.coffee

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
    # do () =>
        # inherited = @_getValueFromParam.bind(@)
        # @_getValueFromParam = (value) ->
        #     return ~~inherited(value)

    # _pool, _fromPool are inherited

    @parse: (str) ->
        if mathJS.isNum(parsed = parseInt(str, 10))
            return @_fromPool parsed
        return parsed

    @random: (max, min) ->
        return @_fromPool mathJS.randInt(max, min)

    @getSet: () ->
        return mathJS.Domains.N

    ###*
    * @Override mathJS.Poolable
    * @static
    * @method _fromPool
    *###
    @_fromPool: (value) ->
        if @_pool.length > 0
            if (val = @_getPrimitiveInt(value))?
                number = @_pool.pop()
                number.value = val.value or val
                return number
            throw new mathJS.Errors.InvalidParametersError(
                "Can't instatiate number from given '#{value}'"
                "Int.coffee"
                undefined
                value
            )
        # param check is done in constructor
        return new @(value)

    @_getPrimitiveInt: (param, skipCheck) ->
        if skipCheck is true
            return param

        if param instanceof mathJS.Int
            return param.value

        if param instanceof mathJS.Number
            return ~~param.value

        if param instanceof Number
            return ~~param.valueOf()

        if mathJS.isNum(param)
            return ~~param

        return null


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


    # plus: (n) ->
    #     return @constructor._fromPool ~~(@value + @_getValueFromParam(n))
    #
    # increase: (n) ->
    #     @value += ~~@_getValueFromParam(n)
    #     return @
    #
    # plusSelf: @increase
    #
    # minus: (n) ->
    #     return @constructor._fromPool ~~(@value - n)
    #
    # decrease: (n) ->
    #     @value = ~~(@value - @_getValueFromParam(n)) # when rounding is done matters when substracting (in contrary to addition)
    #     return @
    #
    # minusSelf: @decrease
    #
    # times: (n) ->
    #     return @constructor._fromPool ~~(@value * @_getValueFromParam(n))
    #
    # timesSelf: (n) ->
    #     @value = ~~(@value * @_getValueFromParam(n)) # same as substraction
    #     return @
    #
    # divide: (n) ->
    #     return @constructor._fromPool ~~(@value / @_getValueFromParam(n))
    #
    # divideSelf: (n) ->
    #     @value = ~~(@value / @_getValueFromParam(n))
    #     return @
    #
    # sqrt: () ->
    #     return @constructor._fromPool ~~(mathJS.sqrt @value)
    #
    # sqrtSelf: () ->
    #     @value = ~~mathJS.sqrt(@value)
    #     return @
    #
    # pow: (n) ->
    #     return @constructor._fromPool(mathJS.pow @value, @_getValueFromParam(n))
    #
    # powSelf: (n) ->
    #     @value = mathJS.pow @value, @_getValueFromParam(n)
    #     return @

    toInt: () ->
        return mathJS.Int._fromPool @value

    getSet: () ->
        return mathJS.Domains.N
# end js/Numbers/Int.coffee

# from js/Numbers/Fraction.coffee
class mathJS.Fraction extends mathJS.Number

    ###*
    * @Override mathJS.Number
    * @static
    * @method _fromPool
    *###
    @_fromPool: (e, d) ->
        if @_pool.length > 0
            if @valueIsValid val
                frac = @_pool.pop()
                frac.enumerator = e.value or e
                frac.denominator = d.value or d
                return frac
            return null
        else
            # param check is done in constructor
            return new @(e, d)

    ###*
    * @Override mathJS.Number
    * @static
    * @method parse
    *###
    # x / y
    @parse: (str) ->
        if "/" in str
            parts = str.split "/"
        else if ":" in str
            parts = str.slit ":"
        return @new parts.first, parts.second

    ###*
    * @Override mathJS.Number
    * @static
    * @method getSet
    *###
    @getSet: () ->
        return mathJS.Domains.Q

    ###*
    * @Override mathJS.Number
    * @static
    * @method new
    *###
    @new: (e, d) ->
        return @_fromPool e, d

    ###########################################################################
    # CONSTRUCTOR
    constructor: (enumerator, denominator) ->
        # number objects
        if enumerator instanceof mathJS.Number and denominator instanceof mathJS.Number
            @enumerator = enumerator.toInt()
            @denominator = denominator.toInt()
        # assume primitives
        else
            @enumerator = ~~enumerator
            @denominator = ~~denominator
# end js/Numbers/Fraction.coffee

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
# TODO: maybe extend mathJS.Vector instead?! or mix them
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
    * This method creates an object with the keys "real" and "img" which have primitive numbers as their values.
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


    @_fromPool: (real, img) ->
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
                return @_fromPool real, img

        return NaN

    @random: (max1, min1, max2, min2) ->
        return @_fromPool mathJS.randNum(max1, min1), mathJS.randNum(max2, min2)


    ###########################################################################
    # CONSTRUCTOR
    constructor: (real, img) ->
        values = @_getValueFromParam(real, img)

        # if not values?
        #     fStr = arguments.callee.caller.toString()
        #     throw new Error("mathJS: Expected 2 numbers or a complex number! Given (#{real}, #{img}) in \"#{fStr.substring(0, fStr.indexOf(")") + 1)}\"")

        Object.defineProperties @, {
            real:
                get: @_getReal
                set: @_setReal
            img:
                get: @_getImg
                set: @_setImg
            _fromPool:
                value: @constructor._fromPool.bind(@constructor)
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
            return @_fromPool(@real + values.real, @img + values.img)
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
            return @_fromPool(@real - values.real, @img - values.img)
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
        # return @_fromPool(@value * _getValueFromParam(n))
        values = @_getValueFromParam(r, i)
        if values?
            return @_fromPool(@real * values.real, @img * values.img)
        return NaN

    timesSelf: (n) ->
        @value *= _getValueFromParam(n)
        return @

    divide: (n) ->
        return @_fromPool(@value / _getValueFromParam(n))

    divideSelf: (n) ->
        @value /= _getValueFromParam(n)
        return @

    square: () ->
        return @_fromPool(@value * @value)

    squareSelf: () ->
        @value *= @value
        return @

    cube: () ->
        return @_fromPool(@value * @value * @value)

    squareSelf: () ->
        @value *= @value * @value
        return @

    sqrt: () ->
        return @_fromPool(mathJS.sqrt @value)

    sqrtSelf: () ->
        @value = mathJS.sqrt @value
        return @

    pow: (n) ->
        return @_fromPool(mathJS.pow @value, _getValueFromParam(n))

    powSelf: (n) ->
        @value = mathJS.pow @value, _getValueFromParam(n)
        return @

    sign: () ->
        return mathJS.sign @value

    toInt: () ->
        return mathJS.Int._fromPool mathJS.floor(@value)

    toDouble: () ->
        return mathJS.Double._fromPool @value

    toString: () ->
        return "#{PARSE_KEY}#{@real.toString()},#{@img.toString()}"

    clone: () ->
        return @_fromPool(@value)

    # add instance to pool
    release: () ->
        @constructor._pool.push @
        return @constructor
# end js/Numbers/Complex.coffee

# from js/Algorithms/ShuntingYard.coffee
# from http://rosettacode.org/wiki/Parsing/Shunting-yard_algorithm
class mathJS.Algorithms.ShuntingYard

    CLASS = @

    @specialOperators =
        # unary plus/minus
        "+" : "#"
        "-" : "_"

    @init = () ->
        @specialOperations =
            "#": mathJS.Operations.neutralPlus
            "_": mathJS.Operations.negate


    constructor: (settings) ->
        @ops = ""
        @precedence = {}
        @associativity = {}

        for op, opSettings of settings
            @ops += op
            @precedence[op] = opSettings.precedence
            @associativity[op] = opSettings.associativity

    isOperand = (token) ->
        return mathJS.isNum(token)

    toPostfix: (str) ->
        # remove spaces
        str = str.replace /\s+/g, ""
        # make implicit multiplication explicit (3x=> 3*x, xy => x*y)
        # TODO: what if a variable/function has more than 1 character: 3*abs(-3)
        str = str.replace /(\d+|\w)(\w)/g,"$1*$2"

        stack = []
        ops = @ops
        precedence = @precedence
        associativity = @associativity
        postfix = ""
        # set string property to indicate format
        postfix.postfix = true

        for token, i in str
            # if token is an operator
            if token in ops
                o1 = token
                o2 = stack.last()

                # handle unary plus/minus => just add special char
                if i is 0 or prevToken is "("
                    if CLASS.specialOperators[token]?
                        postfix += "#{CLASS.specialOperators[token]} "
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
            # token is an operand or a variable
            else
                postfix += "#{token} "

            prevToken = token

            # console.log token, stack

        while stack.length > 0
          postfix += "#{stack.pop()} "

        return postfix.trim()

    toExpression: (str) ->
        if not str.postfix?
            postfix = @toPostfix(str)
        else
            postfix = str

        postfix = postfix.split " "

        # gather all operators
        ops = @ops
        for k, v of CLASS.specialOperators
            ops += v

        i = 0

        # while expression tree is not complete
        while postfix.length > 1
            token = postfix[i]
            idxOffset = 0

            if token in ops
                if (op = mathJS.Operations[token])
                    startIdx = i - op.arity
                    endIdx = i
                else if (op = CLASS.specialOperations[token])
                    startIdx = i + 1
                    endIdx = i + op.arity + 1
                    idxOffset = -1

                params = postfix.slice(startIdx, endIdx)

                startIdx += idxOffset

                # # convert parameter strings to mathJS objects
                for param, j in params when typeof param is "string"
                    if isOperand(param)
                        params[j] = new mathJS.Expression(parseFloat(param))
                    else
                        params[j] = new mathJS.Variable(param)

                # create expression from parameters
                exp = new mathJS.Expression(op, params...)
                # this expression replaces the operation and its parameters
                postfix.splice(startIdx, params.length + 1, exp)

                # reset i to the first replaced element index -> increase in next iteration -> new element
                i = startIdx + 1

            # constants
            else if isOperand(token)
                postfix[i++] = new mathJS.Expression(parseFloat(token))
            # variables
            else
                postfix[i++] = new mathJS.Variable(token)

        return postfix.first
# end js/Algorithms/ShuntingYard.coffee

# from js/Formals/Operation.coffee
class mathJS.Operation

    constructor: (name, precedence, associativity="left", commutative, func, inverse, setEquivalent) ->
        @name = name
        @precedence = precedence
        @associativity = associativity
        @commutative = commutative
        @func = func
        @arity = func.length # number of parameters => unary, binary, ternary...
        @inverse = inverse or null
        @setEquivalent = setEquivalent or null

    eval: (args) ->
        return @func.apply(@, args)

    invert: () ->
        if @inverse?
            return @inverse.apply(@, arguments)
        return null

# ABSTRACT OPERATIONS
# Those functions make sure primitives are converted correctly and calls the according operation on it"s first argument.
# They are the actual functions of the operations.
# TODO: no DRY
mathJS.Abstract =
    Operations:
        # arithmetical
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
        negate: (x) ->
            if mathJS.Number.valueIsValid(x)
                x = new mathJS.Number(x)
            return x.negate()
        unaryPlus: (x) ->
            if mathJS.Number.valueIsValid(x)
                x = new mathJS.Number(x)
            return x.clone()
        # boolean / logical (converting from primitives to numbers doesn"t make sense because 3 and 4 is not defined)
        and: (x, y) ->
            return x.and(y)
        or: (x, y) ->
            return x.or(y)
        not: (x) ->
            return x.not()
        nand: (x, y) ->
            return x.nand(y)
        nor: (x, y) ->
            return x.nor(y)
        xor: (x, y) ->
            return x.xor(y)
        equals: (x, y) ->
            return x.equals(y)

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
        mathJS.factorialInverse
    )
    negate: new mathJS.Operation(
        "negate"
        11
        "none"
        false
        mathJS.Abstract.Operations.negate
        mathJS.Abstract.Operations.negate
    )
    unaryPlus: new mathJS.Operation(
        "unaryPlus"
        11
        "none"
        false
        mathJS.Abstract.Operations.unaryPlus
        mathJS.Abstract.Operations.unaryPlus
    )
    and: new mathJS.Operation(
        "and"
        1
        "left"
        true
        mathJS.Abstract.Operations.and
        null
        "intersection"
    )
    or: new mathJS.Operation(
        "or"
        1
        "left"
        true
        mathJS.Abstract.Operations.or
        null
        "union"
    )
    not: new mathJS.Operation(
        "not"
        5
        "none"
        false
        mathJS.Abstract.Operations.not
        mathJS.Abstract.Operations.not
        "complement"
    )
    nand: new mathJS.Operation(
        "nand"
        1
        "left"
        true
        mathJS.Abstract.Operations.nand
        null
    )
    nor: new mathJS.Operation(
        "nor"
        1
        "left"
        true
        mathJS.Abstract.Operations.nor
        null
    )
    xor: new mathJS.Operation(
        "xor"
        1
        "left"
        true
        mathJS.Abstract.Operations.xor
        null
    )
    equals: new mathJS.Operation(
        "equals"
        1
        "left"
        true
        mathJS.Abstract.Operations.equals
        null
        "intersection"
    )


mathJS.Operations =
    # arithmetical
    "+":            cached.addition
    "plus":         cached.addition
    "-":            cached.subtraction
    "minus":        cached.subtraction
    "*":            cached.multiplication
    "times":        cached.multiplication
    "/":            cached.division
    ":":            cached.division
    "divide":       cached.division
    "^":            cached.exponentiation
    "pow":          cached.exponentiation
    "!":            cached.factorial
    "negate":       cached.negate
    "-u":           cached.negate
    "u-":           cached.negate
    "unaryMinus":   cached.negate
    "neutralMinus": cached.negate
    "+u":           cached.unaryPlus
    "u+":           cached.unaryPlus
    "unaryPlus":    cached.unaryPlus
    "neutralPlus":  cached.unaryPlus
    # logical
    "and":          cached.and
    "or":           cached.or
    "not":          cached.not
    "nand":         cached.nand
    "nor":          cached.nor
    "xor":          cached.xor
    "equals":       cached.equals
    "=":            cached.equals
    "xnor":         cached.equals
# end js/Formals/Operation.coffee

# from js/Formals/Expression.coffee
###*
* Tree structure of expressions. It consists of 2 expression and 1 operation.
* @class Expression
* @constructor
* @param operation {Operation|String}
* @param expressions... {Expression}
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
                throw new mathJS.Errors.InvalidParametersError("Invalid operation string given: \"#{operation}\".")

        # if constructor was called from static .new()
        if expressions.first instanceof Array
            expressions = expressions.first

        # just 1 parameter => constant/value or hash given
        if expressions.length is 0
            # constant/variable value given => leaf in expression tree
            if mathJS.Number.valueIsValid(operation)
                @operation = null
                @expressions = [new mathJS.Number(operation)]
            else
                if operation instanceof mathJS.Variable
                    @operation = null
                    @expressions = [operation]
                # variable string. eg. "x"
                else
                    @operation = null
                    @expressions = [new mathJS.Variable(operation)]
            # else
            #     throw new mathJS.Errors.InvalidParametersError("...")

        else if operation.arity is expressions.length
            @operation = operation
            @expressions = expressions
        else
            throw new mathJS.Errors.InvalidArityError("Invalid number of parameters (#{expressions.length}) for Operation \"#{operation.name}\". Expected number of parameters is #{operation.arity}.")

    ###*
    * This method tests for the equality of structure. So 2*3x does not equal 6x!
    * For that see mathEquals().
    * @method equals
    *###
    equals: (expression) ->
        # immediate return if different number of sub expressions
        if @expressions.length isnt expression.expressions.length
            return false

        # leaf -> anchor
        if not @operation?
            return not expression.operation? and expression.expressions.first.equals(@expressions.first)

        # order of expressions doesnt matter
        if @operation.commutative is true
            doneExpressions = []
            for exp, i in @expressions
                res = false
                for x, j in expression.expressions when j not in doneExpressions and x.equals(exp)
                    doneExpressions.push j
                    res = true
                    break

                # exp does not equals any of the expressions => return false
                if not res
                    return false

            return true
        # order of expressions matters
        else
            # res = true
            for e1, i in @expressions
                e2 = expression.expressions[i]
                # res = res and e1.equals(e2)
                if not e1.equals(e2)
                    return false
            # return res
            return true

    ###*
    * This method tests for the logical/mathematical equality of 2 expressions.
    *###
    # TODO: change naming here! equals should always be mathematical!!!
    mathEquals: (expression) ->
        return @simplify().equals expression.simplify()

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
            # evaluated expression is a variable => stop because this and the "above" expression cant be evaluated further
            value = expression.eval(values)
            if value instanceof mathJS.Variable
                return @
            # evaluation succeeded => add to list of evaluated values (which will be passed to the operation)
            args.push value

        return @operation.eval(args)

    simplify: () ->
        # simplify numeric values aka. non-variable arithmetics
        evaluated = @eval()
        # actual simplification: less ops!
        # TODO: gather simplification patterns
        return @

    getVariables: () ->
        if not @operation?
            if (val = @expressions.first) instanceof mathJS.Variable
                return [val]
            return []

        res = []
        for expression in @expressions
            res = res.concat expression.getVariables()
        return res

    _getSet: () ->
        # leaf
        if not @operation?
            return @expressions.first._getSet()

        # no leaf
        res = null
        for expression in @expressions
            if res?
                res = res[@operation.setEquivalent] expression._getSet()
            else
                res = expression._getSet()

        # TODO: the "or new mathJS.Set()" should be unnecessary
        return res or new mathJS.Set()

    ###*
    * Get the "range" of the expression (the set of all possible results).
    * @method getSet
    *###
    getSet: () ->
        return @eval()._getSet()

    # MAKE ALIASES
    evaluatesTo: @::getSet

    if DEBUG
        @test = () ->
            e1 = new CLASS(5)
            e2 = new CLASS(new mathJS.Variable("x", mathJS.Number))
            e4 = new CLASS("+", e1, e2)
            console.log e4.getVariables()
            # console.log e4.eval({x: new mathJS.Number(5)})
            # console.log e4.eval()
            # e5 = e4.eval()
            # console.log e5.eval({x: new mathJS.Number(5)})

            str = "(5x - 3)  ^ 2 * 2 / (4y + 3!)"

            # (5x-3)^2 * 2 / (4y + 6)

            return "test done"
# end js/Formals/Expression.coffee

# from js/Formals/Variable.coffee
###*
* @class Variable
* @constructor
* @param {String} name
* This is name name of the variable (mathematically)
* @param {mathJS.Set} type
*###
# TODO: make interfaces meta: eg. have a Variable@Evaluable.coffee file that contains the interface and inset on build
# class mathJS.Variable extends mathJS.Evaluable
class mathJS.Variable extends mathJS.Expression

    # TODO: change this to mathJS.Domains.R when R is implemented
    constructor: (name, elementOf=mathJS.Domains.N) ->
        @name = name
        if elementOf.getSet?
            @elementOf = elementOf.getSet()
        else
            @elementOf = elementOf



    _getSet: () ->
        return @elementOf

    equals: (variable) ->
        return @name is variable.name and @elementOf.equals variable.elementOf

    plus: (n) ->
        return new mathJS.Expression("+", @, n)

    minus: (n) ->
        return new mathJS.Expression("-", @, n)

    times: (n) ->
        return new mathJS.Expression("*", @, n)

    divide: (n) ->
        return new mathJS.Expression("/", @, n)

    eval: (values) ->
        if values? and (val = values[@name])?
            if @elementOf.contains val
                return val
            console.warn "Given value \"#{val}\" is not in the set \"#{@elementOf.name}\"."
        return @
# end js/Formals/Variable.coffee

# from js/Formals/Equation.coffee
class mathJS.Equation

    constructor: (left, right) ->
        # if left.mathEquals(right)
        #     @left = left
        #     @right = right
        # else
        #     # TODO: only if no variables are contained
        #     throw new mathJS.Errors.InvalidParametersError("The 2 expressions are not (mathematically) equal!")
        @left = left
        @right = right

    solve: (variable) ->
        left = @left.simplify()
        right = @right.simplify()

        solutions = new mathJS.Set()

        # convert to actual variable if only the name was given
        if variable not instanceof mathJS.Variable
            variables = left.getVariables().concat right.getVariables()
            variable = (v for v in variables when v.name is variable).first

        return solutions

    eval: (values) ->
        return @left.eval(values).equals @right.eval(values)

    simplify: () ->
        @left = @left.simplify()
        @right = @right.simplify()
        return @

    # MAKE ALIASES
    # ...
# end js/Formals/Equation.coffee

# from js/Sets/AbstractSet.coffee
class _mathJS.AbstractSet extends _mathJS.Object

    @implements _mathJS.Orderable, _mathJS.Poolable, _mathJS.Parseable

    @fromString: (str) ->

    @parse: () ->
        return @fromString.apply(@, arguments)

    cartesianProduct: (set) ->

    clone: () ->

    contains: (elem) ->

    equals: (set) ->

    getElements: () ->

    infimum: () ->

    intersection: (set) ->

    isSubsetOf: (set) ->

    min: () ->

    max: () ->

    # PRE-IMPLEMENTED (may be inherited)
    size: () ->
        return Infinity

    supremum: () ->

    union: (set) ->

    intersection: (set) ->

    without: (set) ->


    ###########################################################################
    # PRE-IMPLEMENTED (to be inherited)
    complement: (universe) ->
        return universe.minus(@)

    disjoint: (set) ->
        return @intersection(set).size() is 0

    intersects: (set) ->
        return not @disjoint(set)

    isEmpty: () ->
        return @size() is 0

    isSupersetOf: (set) ->
        return set.isSubsetOf @

    pow: (exponent) ->
        sets = []
        for i in [0...exponent]
            sets.push @
        return @cartesianProduct.apply(@, sets)

    ###########################################################################
    # ALIASES
    @_makeAliases: () ->
        aliasesData =
            size:               ["cardinality"]
            without:            ["difference", "except", "minus"]
            contains:           ["has"]
            intersection:       ["intersect"]
            isSubsetOf:         ["subsetOf"]
            isSupersetOf:       ["supersetOf"]
            cartesianProduct:   ["times"]

        for orig, aliases of aliasesData
            for alias in aliases
                @::[alias] = @::[orig]

        return @

    @_makeAliases()
# end js/Sets/AbstractSet.coffee

# from js/Sets/Set.coffee
###*
* @class Set
* @constructor
* @param {mixed} specifications
* To create an empty set pass no parameters.
* To create a discrete set list the elements. Those elements must implement the comparable interface and must not be arrays. Non-comparable elements will be ignored unless they are primitives.
* To create a set from set-builder notation pass the parameters must have the following types:
* mathJS.Expression|mathJS.Tuple|mathJS.Number, mathJS.Predicate
# TODO: package all those types (expression-like) into 1 prototype (Variable already is)
*###
class mathJS.Set extends _mathJS.AbstractSet

    ###########################################################################
    # STATIC

    ###*
    * Optionally the left and right configuration can be passed directly (each with an open- and value-property) or the Interval can be parsed from String (like "(2, 6 ]").
    * @static
    * @method createInterval
    * @param leftOpen {Boolean}
    * @param leftValue {Number|mathJS.Number}
    * @param rightValue {Number|mathJS.Number}
    * @param rightOpen {Boolean}
    *###
    @createInterval: (parameters...) ->
        if typeof (str = parameters.first) is "string"
            # remove spaces
            str = str.replace /\s+/g, ""
                     .split ","

            left =
                open: str.first[0] is "("
                value: new mathJS.Number(parseInt(str.first.slice(1), 10))
            right =
                open: str.second.last is ")"
                value: new mathJS.Number(parseInt(str.second.slice(0, -1), 10))
        # # first parameter has an .open property => assume ctor called from fromString()
        # else if parameters.first.open?
        #     left = parameters.first
        #     right = parameters.second
        else
            second = parameters.second
            fourth = parameters.fourth
            left =
                open: parameters.first
                value: (if second instanceof mathJS.Number then second else new mathJS.Number(second))
            right =
                open: parameters.third
                value: (if fourth instanceof mathJS.Number then fourth else new mathJS.Number(fourth))

        # an interval can be expressed with a conditional set: (a,b) = {x | x in R, a < x < b}
        expression = new mathJS.Variable("x", mathJS.Domains.N)
        predicate = null

        return new mathJS.Set(expression, predicate)


    ###########################################################################
    # CONSTRUCTOR
    constructor: (parameters...) ->
        # ANALYSE PARAMETERS
        # nothing passed => empty set
        if parameters.length is 0
            @discreteSet = new _mathJS.DiscreteSet()
            @conditionalSet = new _mathJS.ConditionalSet()

        # discrete and conditional set given (from internal calls like union())
        else if parameters.first instanceof _mathJS.DiscreteSet and parameters.second instanceof _mathJS.ConditionalSet
            @discreteSet = parameters.first
            @conditionalSet = parameters.second
        # set-builder notation
        else if parameters.first instanceof mathJS.Expression and parameters.second instanceof mathJS.Expression
            console.log "set builder"
            @discreteSet = new _mathJS.DiscreteSet()
            @conditionalSet = new _mathJS.ConditionalSet(parameters.first, parameters.slice(1))
        # discrete set
        else
            # array given -> make its elements the set elements
            if parameters.first instanceof Array
                parameters = parameters.first

            console.log "params:", parameters

            @discreteSet = new _mathJS.DiscreteSet(parameters)
            @conditionalSet = new _mathJS.ConditionalSet()


    ###########################################################################
    # PRIVATE METHODS
    # TODO: inline the following 2 if used nowhere else
    newFromDiscrete = (set) ->
        return new mathJS.Set(set.getElements())

    newFromConditional = (set) ->
        return new mathJS.Set(set.expression, set.domains, set.predicate)

    ###########################################################################
    # PROTECTED METHODS

    ###########################################################################
    # PUBLIC METHODS
    getElements: (n=mathJS.config.set.defaultNumberOfElements, sorted=false) ->
        res = @discreteSet.elems.concat(@conditionalSet.getElements(n, sorted))

        if sorted isnt true
            return res

        return res.sort(mathJS.sortFunction)

    size: () ->
        return @discreteSet.size() + @conditionalSet.size()

    clone: () ->
        return newFromDiscrete(@discreteSet).union(newFromConditional(@conditionalSet))

    equals: (set) ->
        if set.size() isnt @size()
            return false
        return set.discreteSet.equals(@discreteSet) and set.conditionalSet.equals(@conditionalSet)

    getSet: () ->
        return @

    isSubsetOf: (set) ->
        return @conditionalSet.isSubsetOf(set) or @discreteSet.isSubsetOf(set)

    isSupersetOf: (set) ->
        return @conditionalSet.isSupersetOf(set) or @discreteSet.isSupersetOf(set)

    contains: (elem) ->
        return @conditionalSet.contains(@conditionalSet) or @discreteSet.contains(@discreteSet)

    union: (set) ->
        # if domain (N, Z, Q, R, C) let it handle the union because it knows know more about itself than this does
        # also domains have neither discrete nor conditional sets
        if set.isDomain
            return set.union(@)
        return new mathJS.Set(@discreteSet.union(set.discreteSet), @conditionalSet.union(set.conditionalSet))

    intersection: (set) ->
        if set.isDomain
            return set.intersection(@)
        return new mathJS.Set(@discreteSet.intersection(set.discreteSet), @conditionalSet.intersection(set.conditionalSet))

    complement: () ->
        if @universe?
            return asdf
        return new mathJS.EmptySet()

    without: (set) ->

    cartesianProduct: (set) ->

    min: () ->
        return mathJS.min(@discreteSet.min().concat @conditionalSet.min())

    max: () ->
        return mathJS.max(@discreteSet.max().concat @conditionalSet.max())

    infimum: () ->

    supremum: () ->
# end js/Sets/Set.coffee

# from js/Sets/DiscreteSet.coffee
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
class _mathJS.DiscreteSet extends mathJS.Set

    ###########################################################################
    # CONSTRUCTOR
    constructor: (elems...) ->
        if elems.first instanceof Array
            elems = elems.first

        @elems = []

        for elem in elems when not @contains(elem)
            if not mathJS.isNum(elem)
                @elems.push elem
            else
                @elems.push new mathJS.Number(elem)

    ###########################################################################
    # PROTECTED METHODS


    ###########################################################################
    # PUBLIC METHODS

    # discrete sets only!
    cartesianProduct: (set) ->
        elements = []
        for e in @elems
            for x in set.elems
                elements.push new mathJS.Tuple(e, x)

        return new _mathJS.DiscreteSet(elements)

    clone: () ->
        return new _mathJS.DiscreteSet(@elems)

    contains: (elem) ->
        for e in @elems when elem.equals e
            return true
        return false

    # discrete sets only!
    equals: (set) ->
        # return @isSubsetOf(set) and set.isSubsetOf(@)
        for e in @elems when not set.contains e
            return false

        for e in set.elems when not @contains e
            return false

        return true

    ###*
    * Get the elements of the set.
    * @method getElements
    * @param sorted {Boolean}
    * Optional. If set to `true` returns the elements in ascending order.
    *###
    getElements: (sorted) ->
        if sorted isnt true
            return @elems.clone()
        return @elems.clone().sort(mathJS.sortFunction)

    # discrete sets only!
    intersection: (set) ->
        elems = []
        for x in @elems
            for y in set.elems when x.equals y
                elems.push x

        return new _mathJS.DiscreteSet(elems)

    isSubsetOf: (set) ->
        for e in @elems when not set.contains e
            return false
        return true

    size: () ->
        # TODO: cache size
        return @elems.length

    # discrete sets only!
    union: (set) ->
        return new _mathJS.DiscreteSet(set.elems.concat(@elems))

    without: (set) ->
        return (elem for elem in @elems when not set.contains elem)

    min: () ->
        return mathJS.min @elems

    max: () ->
        return mathJS.max @elems

    infimum: () ->

    supremum: () ->

    @_makeAliases()
# end js/Sets/DiscreteSet.coffee

# from js/Sets/ConditionalSet.coffee
class _mathJS.ConditionalSet extends mathJS.Set

    CLASS = @

    ###
    {2x^2 | x in R and 0 <= x < 20 and x = x^2} ==> {0, 1}
    x in R and 0 <= x < 20 and x = x^2 <=> R intersect [0, 20) intersect {0,1} (where 0 and 1 have to be part of the previous set)
    do the following:
    1. map domains to domains
    2. map unequations to intervals
    3. map equations to (discrete?!) sets
    4. create intersection of all!

    simplifications:
    1.  domains intersect interval = interval (because in this notation the domain is the superset)
        so it wouldnt make sense to say: x in N and x in [0, 10] and expect the set to be infinite!!
        the order does not matter (otherwise (x in [0, 10] and x in N) would be infinite!!)
    2.  when trying to get equation solutions numerically (should this ever happen??) look for interval first to get boundaries
    ###

    # predicate is an boolean expression
    # TODO: try to find out if the set is actually discrete!
    # TODO: maybe a 3rd parameter "baseSet" should be passed to indicate where the generator comes from
    # TODO: predicate could also be the base set itself. if not it must be derived from the (boolean) predicate
    # TODO: predicate's type is Expression.Boolean
    constructor: (expression, predicate) ->
        # empty set
        if arguments.length is 0
            @generator = null
        # non-empty set
        else if expression instanceof mathJS.Generator
            @generator = expression
        # no generator passed => standard parameters
        else
            if predicate instanceof mathJS.Expression
                predicate = predicate.getSet()

            # f, minX=0, maxX=Infinity, stepSize=mathJS.config.number.real.distance, maxIndex=mathJS.config.generator.maxIndex, tuple
            @generator = new mathJS.Generator(
                # f: predicate -> ?? (expression.getSet())
                # x |-> expression(x)
                new mathJS.Function("f", expression, predicate, expression.getSet())
                predicate.min()
                predicate.max()
            )

    cartesianProduct: (sets...) ->
        generators = [@generator].concat(set.generator for set in sets)
        return new _mathJS.ConditionalSet(mathJS.Generator.product(generators...))

    clone: () ->
        return new CLASS()

    contains: (elem) ->
        if mathJS.isComparable elem
            if @condition?.check(elem) is true
                return true
        return false

    equals: (set) ->
        if set instanceof CLASS
            return @generator.f.equals set.generator.f
        # normal set
        return set.discreteSet.isEmpty() and @generator.f.equals set.conditionSet.generator.f

    getElements: (n, sorted) ->
        res = []
        # TODO
        return res

    # TODO: "and" generators
    intersection: (set) ->

    isSubsetOf: (set) ->

    isSupersetOf: (set) ->

    size: () ->
        return @generator.f.range.size()

    # TODO: "or" generators
    union: (set) ->

    without: (set) ->


    @_makeAliases()

    if DEBUG
        @test = () ->
            e1 = new mathJS.Expression(5)
            e2 = new mathJS.Expression(new mathJS.Variable("x", mathJS.Number))
            e3 = new mathJS.Expression("+", e1, e2)

            p1 = new mathJS.Expression(new mathJS.Variable("x", mathJS.Number))
            p2 = new mathJS.Expression(4)
            p3 = new mathJS.Expression("=", p1, p2)

            console.log p3.eval(x: 4)

            console.log p3.getSet()

            console.log AAA

            # set = new _mathJS.ConditionalSet(e3, p3)

            # console.log set

            return "done"
# end js/Sets/ConditionalSet.coffee

# from js/Sets/Tuple.coffee
class mathJS.Tuple

    ###########################################################################
    # CONSTRUCTOR
    constructor: (elems...) ->
        if elems.first instanceof Array
            elems = elems.first

        temp = []

        for elem in elems
            if not mathJS.isNum(elem)
                temp.push elem
            else
                temp.push new mathJS.Number(elem)

        @elems = temp
        @_size = temp.length

    ###########################################################################
    # PUBLIC METHODS
    Object.defineProperties @::, {
        first:
            get: () ->
                return @at(0)
            set: () ->
                return @
        length:
            get: () ->
                return @_size
            set: () ->
                return @
    }

    add: (elems...) ->
        return new mathJS.Tuple(@elems.concat(elems))

    at: (idx) ->
        return @elems[idx]

    clone: () ->
        return new mathJS.Tuple(@elems)

    contains: (elem) ->
        for e in @elems when e.equals elem
            return true
        return false

    equals: (tuple) ->
        if @_size isnt tuple._size
            return false

        elements = tuple.elems

        for elem, idx in @elems when not elem.equals elements[idx]
            return false

        return true

    ###*
    * Evaluates the tuple.
    * @param values {Array}
    * # TODO: also enables hash of vars
    * A value for each tuple element.
    *###
    eval: (values) ->
        elems = (elem.eval(values[i]) for elem, i in @elems)
        return new mathJS.Tuple(elems)

    ###*
    * Get the elements of the Tuple.
    * @method getElements
    *###
    getElements: () ->
        return @elems.clone()

    insert: (idx, elems...) ->
        elements = []
        for elem, i in @elems
            if i is idx
                elements = elements.concat(elems)
            elements.push elem

        return new mathJS.Tuple(elements)

    isEmpty: () ->
        return @_size() is 0

    ###*
    * Removes the first occurences of the given elements.
    *###
    remove: (elems...) ->
        elements = @elems.clone()
        for e in elems
            for elem, i in elements when elem.equals e
                elements.splice i, 1
                break

        return new mathJS.Tuple(elements)

    removeAt: (idx, n=1) ->
        elems = []
        for elem, i in @elems when i < idx or i >= idx + n
            elems.push elem

        return new mathJS.Tuple(elems)

    size: () ->
        return @_size

    slice: (startIdx, endIdx=@_size) ->
        return new mathJS.Tuple(@elems.slice(startIdx, endIdx))

    ###########################################################################
    # ALIASES
    cardinality: @::size

    extendBy: @::add

    get: @::at

    has: @::contains

    addAt: @::insert
    insertAt: @::insert

    reduceBy: @::remove
# end js/Sets/Tuple.coffee

# from js/Sets/Function.coffee
class mathJS.Function extends mathJS.Set

    # EQUAL!
    # function:
    # f: X -> Y, f(x) = 3x^2 - 5x + 7
    # set:
    # {(x, 3x^2 - 5x + 7) | x in X}

    # domain is implicit by variables" types contained in the expression
    # range is implicit by the expression
    # constructor: (name, domain, range, expression) ->
    constructor: (name, expression, domain, range) ->
        @name = name
        @expression = expression

        if domain instanceof mathJS.Set
            @domain = domain
        else
            @domain = new mathJS.Set(expression.getVariables())

        if range instanceof mathJS.Set
            @range = range
        else
            @range = expression.getSet()

        @_cache = {}
        @caching = true

        super()

    ###*
    * Empty the cache or reset to given cache.
    * @method clearCache
    * @param cache {Object}
    * @return mathJS.Function
    * @chainable
    *###
    clearCache: (cache) ->
        if not cache?
            @_cache = {}
        else
            @_cache = cache
        return @

    ###*
    * Evaluate the function for given values.
    * @method get
    * @param values {Array|Object}
    * If an array the first value will be associated with the first variable name. Otherwise an object like {x: 42} is expected.
    * @return
    *###
    eval: (values...) ->
        tmp = {}
        if values instanceof Array
            for value, i in values
                tmp[@variableNames[i]] = value
            values = tmp

        # check if values are in domain
        for varName, val of values
            if not domain.contains(val)
                return null

        return @expression.eval(values)

    # make alias
    at: @eval
    get: @eval
# end js/Sets/Function.coffee

# from js/Sets/Generators/AbstractGenerator.coffee
class _mathJS.AbstractGenerator extends _mathJS.Object

    ###########################################################################
    # CONSTRUCTOR
    constructor: (f, minX=0, maxX=Infinity, stepSize=mathJS.config.number.real.distance, maxIndex=mathJS.config.generator.maxIndex, tuple) ->
        @f = f
        @inverseF = f.getInverse()
        @minX = minX
        @maxX = maxX
        @stepSize = stepSize
        @maxIndex = maxIndex
        @tuple = tuple

        @x = minX
        @overflowed = false
        @index = 0

    ###########################################################################
    # DEFINED PROPS
    Object.defineProperties @::, {
        function:
            get: () ->
                return @f
            set: (f) ->
                @f = f
                @inverseF = f.getInverse()
                return @
    }

    ###########################################################################
    # STATIC
    @product: (generators...) ->

    @or: (gen1, gen2) ->

    @and: (gen1, gen2) ->

    ###########################################################################
    # PUBLIC

    ###*
    * Indicates whether the set the generator creates contains the given value or not.
    * @method generates
    *###
    generates: (y) ->
        if @f.range.contains(y)
            #
            if @inverseF?
                return @inverseF.eval(y)
            return
        return false

    eval: (n) ->
        # eval each tuple element individually (the tuple knows how to do that)
        if @tuple?
            return @tuple.eval(n)
        # eval expression
        if @f.eval?
            @f.eval(n)
        # eval js function
        return @f.call(@, n)

    hasNext: () ->
        if @tuple?
            for g, i in @tuple.elems when g.hasNext()
                return true
            return false
        return not @overflowed and @x < @maxX and @index < @maxIndex

    _incX: () ->
        @index++
        # more calculation than just "@x += @stepSize" but more precise!
        @x = @minX + @index * @stepSize

        if @x > @maxX
            @x = @minX
            @index = 0
            @overflowed = true
        return @x

    next: () ->
        if @tuple?
            res = @eval(g.x for g in @tuple.elems)

            ###
            0 0
            0 1
            1 0
            1 1
            ###
            # start binary-like counting (so all possibilities are done)
            i = 0
            maxI = @tuple.length
            generator = @tuple.first
            generator._incX()

            while i < maxI and generator.overflowed
                generator.overflowed = false
                generator = @tuple.at(++i)
                # # "if" needed for very last value -> i should theoretically overflow
                # => i refers to the (n+1)st tuple element (which only has n elements)
                if generator?
                    generator._incX()

            return res

        # no tuple => simple generator
        res = @eval(@x)
        @_incX()
        return res

    reset: () ->
        @x = @minX
        @index = 0
        return @

    if DEBUG
        @test = () ->
            # simple
            g = new mathJS.Generator(
                (x) ->
                    return 3*x*x+2*x-5
                -10
                10
                0.2
            )

            res = []
            while g.hasNext()
                tmp = g.next()
                # console.log tmp
                res.push tmp

            tmp = g.next()
            # console.log tmp
            res.push tmp

            console.log "simple test:", (if res.length is ((g.maxX - g.minX) / g.stepSize + 1) then "successful" else "failed")

            # "nested"
            g1 = new mathJS.Generator(
                (x) -> x,
                0,
                5,
                0.5
            )
            g2 = new mathJS.Generator(
                (x) -> 2*x,
                -2,
                10,
                2
            )
            g = mathJS.Generator.product(g1, g2)

            res = []
            while g.hasNext()
                tmp = g.next()
                res.push tmp
                # console.log (x.value for x in tmp.elems)

            tmp = g.next()
            res.push tmp
            # console.log (x.value for x in tmp.elems)

            console.log "tuple test:", (if res.length is ((g1.maxX - g1.minX) / g1.stepSize + 1) * ((g2.maxX - g2.minX) / g2.stepSize + 1) then "successful" else "failed")

            g = new mathJS.Generator((x) -> x)

            while g.hasNext()
                tmp = g.next()
                # console.log tmp
            tmp = g.next()
            # console.log tmp

            return "done"
# end js/Sets/Generators/AbstractGenerator.coffee

# from js/Sets/Generators/DiscreteGenerator.coffee
class mathJS.DiscreteGenerator extends _mathJS.AbstractGenerator

    ###########################################################################
    # CONSTRUCTOR
    constructor: (f, minX=0, maxX=Infinity, stepSize=mathJS.config.number.real.distance, maxIndex=mathJS.config.generator.maxIndex, tuple) ->
        @f = f
        @inverseF = f.getInverse()
        @minX = minX
        @maxX = maxX
        @stepSize = stepSize
        @maxIndex = maxIndex
        @tuple = tuple

        @x = minX
        @overflowed = false
        @index = 0

    ###########################################################################
    # DEFINED PROPS
    Object.defineProperties @::, {
        function:
            get: () ->
                return @f
            set: (f) ->
                @f = f
                @inverseF = f.getInverse()
                return @
    }

    ###########################################################################
    # STATIC
    @product: (generators...) ->
        return new mathJS.Generator(null, 0, Infinity, null, null, new mathJS.Tuple(generators))

    @or: () ->

    @and: () ->

    ###########################################################################
    # PUBLIC

    ###*
    * Indicates whether the set the generator creates contains the given value or not.
    * @method generates
    *###
    generates: (y) ->
        if @f.range.contains(y)
            #
            if @inverseF?
                return @inverseF.eval(y)
            return
        return false

    eval: (n) ->
        # eval each tuple element individually (the tuple knows how to do that)
        if @tuple?
            return @tuple.eval(n)
        # eval expression
        if @f.eval?
            @f.eval(n)
        # eval js function
        return @f.call(@, n)

    hasNext: () ->
        if @tuple?
            for g, i in @tuple.elems when g.hasNext()
                return true
            return false
        return not @overflowed and @x < @maxX and @index < @maxIndex

    _incX: () ->
        @index++
        # more calculation than just "@x += @stepSize" but more precise!
        @x = @minX + @index * @stepSize

        if @x > @maxX
            @x = @minX
            @index = 0
            @overflowed = true
        return @x

    next: () ->
        if @tuple?
            res = @eval(g.x for g in @tuple.elems)

            ###
            0 0
            0 1
            1 0
            1 1
            ###
            # start binary-like counting (so all possibilities are done)
            i = 0
            maxI = @tuple.length
            generator = @tuple.first
            generator._incX()

            while i < maxI and generator.overflowed
                generator.overflowed = false
                generator = @tuple.at(++i)
                # # "if" needed for very last value -> i should theoretically overflow
                # => i refers to the (n+1)st tuple element (which only has n elements)
                if generator?
                    generator._incX()

            return res

        # no tuple => simple generator
        res = @eval(@x)
        @_incX()
        return res

    reset: () ->
        @x = @minX
        @index = 0
        return @

    if DEBUG
        @test = () ->
            # simple
            g = new mathJS.Generator(
                (x) ->
                    return 3*x*x+2*x-5
                -10
                10
                0.2
            )

            res = []
            while g.hasNext()
                tmp = g.next()
                # console.log tmp
                res.push tmp

            tmp = g.next()
            # console.log tmp
            res.push tmp

            console.log "simple test:", (if res.length is ((g.maxX - g.minX) / g.stepSize + 1) then "successful" else "failed")

            # "nested"
            g1 = new mathJS.Generator(
                (x) -> x,
                0,
                5,
                0.5
            )
            g2 = new mathJS.Generator(
                (x) -> 2*x,
                -2,
                10,
                2
            )
            g = mathJS.Generator.product(g1, g2)

            res = []
            while g.hasNext()
                tmp = g.next()
                res.push tmp
                # console.log (x.value for x in tmp.elems)

            tmp = g.next()
            res.push tmp
            # console.log (x.value for x in tmp.elems)

            console.log "tuple test:", (if res.length is ((g1.maxX - g1.minX) / g1.stepSize + 1) * ((g2.maxX - g2.minX) / g2.stepSize + 1) then "successful" else "failed")

            g = new mathJS.Generator((x) -> x)

            while g.hasNext()
                tmp = g.next()
                # console.log tmp
            tmp = g.next()
            # console.log tmp

            return "done"
# end js/Sets/Generators/DiscreteGenerator.coffee

# from js/Sets/Generators/ContinuousGenerator.coffee
class mathJS.ContinuousGenerator extends _mathJS.AbstractGenerator

    ###########################################################################
    # CONSTRUCTOR
    constructor: (f, minX=0, maxX=Infinity, stepSize=mathJS.config.number.real.distance, maxIndex=mathJS.config.generator.maxIndex, tuple) ->
        @f = f
        @inverseF = f.getInverse()
        @minX = minX
        @maxX = maxX
        @stepSize = stepSize
        @maxIndex = maxIndex
        @tuple = tuple

        @x = minX
        @overflowed = false
        @index = 0

    ###########################################################################
    # DEFINED PROPS
    Object.defineProperties @::, {
        function:
            get: () ->
                return @f
            set: (f) ->
                @f = f
                @inverseF = f.getInverse()
                return @
    }

    ###########################################################################
    # STATIC
    @product: (generators...) ->
        return new mathJS.Generator(null, 0, Infinity, null, null, new mathJS.Tuple(generators))

    @or: () ->

    @and: () ->

    ###########################################################################
    # PUBLIC

    ###*
    * Indicates whether the set the generator creates contains the given value or not.
    * @method generates
    *###
    generates: (y) ->
        if @f.range.contains(y)
            #
            if @inverseF?
                return @inverseF.eval(y)
            return
        return false

    eval: (n) ->
        # eval each tuple element individually (the tuple knows how to do that)
        if @tuple?
            return @tuple.eval(n)
        # eval expression
        if @f.eval?
            @f.eval(n)
        # eval js function
        return @f.call(@, n)

    hasNext: () ->
        if @tuple?
            for g, i in @tuple.elems when g.hasNext()
                return true
            return false
        return not @overflowed and @x < @maxX and @index < @maxIndex

    _incX: () ->
        @index++
        # more calculation than just "@x += @stepSize" but more precise!
        @x = @minX + @index * @stepSize

        if @x > @maxX
            @x = @minX
            @index = 0
            @overflowed = true
        return @x

    next: () ->
        if @tuple?
            res = @eval(g.x for g in @tuple.elems)

            ###
            0 0
            0 1
            1 0
            1 1
            ###
            # start binary-like counting (so all possibilities are done)
            i = 0
            maxI = @tuple.length
            generator = @tuple.first
            generator._incX()

            while i < maxI and generator.overflowed
                generator.overflowed = false
                generator = @tuple.at(++i)
                # # "if" needed for very last value -> i should theoretically overflow
                # => i refers to the (n+1)st tuple element (which only has n elements)
                if generator?
                    generator._incX()

            return res

        # no tuple => simple generator
        res = @eval(@x)
        @_incX()
        return res

    reset: () ->
        @x = @minX
        @index = 0
        return @

    if DEBUG
        @test = () ->
            # simple
            g = new mathJS.Generator(
                (x) ->
                    return 3*x*x+2*x-5
                -10
                10
                0.2
            )

            res = []
            while g.hasNext()
                tmp = g.next()
                # console.log tmp
                res.push tmp

            tmp = g.next()
            # console.log tmp
            res.push tmp

            console.log "simple test:", (if res.length is ((g.maxX - g.minX) / g.stepSize + 1) then "successful" else "failed")

            # "nested"
            g1 = new mathJS.Generator(
                (x) -> x,
                0,
                5,
                0.5
            )
            g2 = new mathJS.Generator(
                (x) -> 2*x,
                -2,
                10,
                2
            )
            g = mathJS.Generator.product(g1, g2)

            res = []
            while g.hasNext()
                tmp = g.next()
                res.push tmp
                # console.log (x.value for x in tmp.elems)

            tmp = g.next()
            res.push tmp
            # console.log (x.value for x in tmp.elems)

            console.log "tuple test:", (if res.length is ((g1.maxX - g1.minX) / g1.stepSize + 1) * ((g2.maxX - g2.minX) / g2.stepSize + 1) then "successful" else "failed")

            g = new mathJS.Generator((x) -> x)

            while g.hasNext()
                tmp = g.next()
                # console.log tmp
            tmp = g.next()
            # console.log tmp

            return "done"
# end js/Sets/Generators/ContinuousGenerator.coffee

# from js/Sets/Domains/Domain.coffee
###*
* Domain ranks are like so:
* N -> 0
* Z -> 1
* Q -> 2
* I -> 2
* R -> 3
* C -> 4
* ==> union: take greater rank (if equal (and unequal names) take next greater rank)
* ==> intersection: take smaller rank (if equal (and unequal names) take empty set)
*###
class _mathJS.Sets.Domain extends _mathJS.AbstractSet

    CLASS = @

    @new: () ->
        return new CLASS()

    @_byRank: (rank) ->
        for name, domain of mathJS.Domains when domain.rank is rank
            return domain
        return null

    constructor: (name, rank, isCountable) ->
        @isDomain   = true
        @name       = name
        @rank       = rank
        @isCountable = isCountable

    clone: () ->
        return @constructor.new()

    size: () ->
        return Infinity

    equals: (set) ->
        return set instanceof @constructor

    intersection: (set) ->
        if set.isDomain
            if @name is set.name
                return @
            if @rank < set.rank
                return @
            if @rank > set.rank
                return set
            return new mathJS.Set()
        # TODO !!
        return false

    union: (set) ->
        if set.isDomain
            if @name is set.name
                return @
            if @rank > set.rank
                return @
            if @rank < set.rank
                return set
            return CLASS._byRank(@rank + 1)
        # TODO !!
        return false

    @_makeAliases()
# end js/Sets/Domains/Domain.coffee

# from js/Sets/Domains/N.coffee
class mathJS.Sets.N extends _mathJS.Sets.Domain

    CLASS = @

    @new: () ->
        return new CLASS()

    constructor: () ->
        super("N", 0, true)


    #################################################################################
    # STATIC


    #################################################################################
    # PUBLIC
    contains: (x) ->
        return mathJS.isInt(x) or new mathJS.Int(x).equals(x)

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

        # if the f2-invert of the y-value of f1 lies within f2" domain/universe both ranges include that value
        # or vice versa
        # we know this generator function has N as domain (and as range of course)
        # we even know the set"s generator function also has N as domain as we assume that (because the mapping is always a bijection from N -> X)
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
                # all previous values are unimportant because in the next iteration the new values will BOTH be greater than y1=y2 and the 2 lists contain only smaller elements than y1=y2 so there can"t be a match with the next elements
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
# end js/Sets/Domains/N.coffee

# from js/Sets/Domains/Z.coffee
class mathJS.Sets.Z extends _mathJS.Sets.Domain

    CLASS = @

    @new: () ->
        return new CLASS()

    constructor: () ->
        super("Z", 1, true)

    #################################################################################
    # STATIC


    #################################################################################
    # PUBLIC
    contains: (x) ->
        return new mathJS.Number(x).equals(x)

    ###*
    * This method checks if `this` is a subset of the given set `set`. Since equality must be checked by checking an arbitrary number of values this method actually does the same as `this.equals()`. For `this.equals()` the number of compared elements is 10x bigger.
    *###
    isSubsetOf: (set, n = mathJS.settings.set.maxIterations) ->
        return @equals(set, n * 10)

    isSupersetOf: (set) ->
        if @_isSet set
            return set.isSubsetOf @
        return false

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

    @_makeAliases()


do () ->
    # mathJS.Domains.N = new mathJS.Sets.N()
    Object.defineProperties mathJS.Domains, {
        Z:
            value: new mathJS.Sets.Z()
            writable: false
            enumerable: true
            configurable: false
    }
# end js/Sets/Domains/Z.coffee

# from js/Sets/Domains/Q.coffee
class mathJS.Sets.Q extends _mathJS.Sets.Domain

    CLASS = @

    @new: () ->
        return new CLASS()

    constructor: () ->
        super("Q", 2, true)

    #################################################################################
    # STATIC


    #################################################################################
    # PUBLIC
    contains: (x) ->
        return new mathJS.Number(x).equals(x)

    ###*
    * This method checks if `this` is a subset of the given set `set`. Since equality must be checked by checking an arbitrary number of values this method actually does the same as `this.equals()`. For `this.equals()` the number of compared elements is 10x bigger.
    *###
    isSubsetOf: (set, n = mathJS.settings.set.maxIterations) ->
        return @equals(set, n * 10)

    isSupersetOf: (set) ->
        if @_isSet set
            return set.isSubsetOf @
        return false

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

    @_makeAliases()


do () ->
    # mathJS.Domains.N = new mathJS.Sets.N()
    Object.defineProperties mathJS.Domains, {
        Q:
            value: new mathJS.Sets.Q()
            writable: false
            enumerable: true
            configurable: false
    }
# end js/Sets/Domains/Q.coffee

# from js/Sets/Domains/I.coffee
class mathJS.Sets.I extends _mathJS.Sets.Domain

    CLASS = @

    @new: () ->
        return new CLASS()

    constructor: () ->
        super("I", 2, false)

    #################################################################################
    # STATIC


    #################################################################################
    # PUBLIC
    contains: (x) ->
        return new mathJS.Number(x).equals(x)

    ###*
    * This method checks if `this` is a subset of the given set `set`. Since equality must be checked by checking an arbitrary number of values this method actually does the same as `this.equals()`. For `this.equals()` the number of compared elements is 10x bigger.
    *###
    isSubsetOf: (set, n = mathJS.settings.set.maxIterations) ->
        return @equals(set, n * 10)

    isSupersetOf: (set) ->
        if @_isSet set
            return set.isSubsetOf @
        return false

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

    @_makeAliases()


do () ->
    # mathJS.Domains.N = new mathJS.Sets.N()
    Object.defineProperties mathJS.Domains, {
        I:
            value: new mathJS.Sets.I()
            writable: false
            enumerable: true
            configurable: false
    }
# end js/Sets/Domains/I.coffee

# from js/Sets/Domains/R.coffee
class mathJS.Sets.R extends _mathJS.Sets.Domain

    CLASS = @

    @new: () ->
        return new CLASS()

    constructor: () ->
        super("R", 3, false)

    #################################################################################
    # STATIC


    #################################################################################
    # PUBLIC
    contains: (x) ->
        return new mathJS.Number(x).equals(x)

    ###*
    * This method checks if `this` is a subset of the given set `set`. Since equality must be checked by checking an arbitrary number of values this method actually does the same as `this.equals()`. For `this.equals()` the number of compared elements is 10x bigger.
    *###
    isSubsetOf: (set, n = mathJS.settings.set.maxIterations) ->
        return @equals(set, n * 10)

    isSupersetOf: (set) ->
        if @_isSet set
            return set.isSubsetOf @
        return false

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

    @_makeAliases()


do () ->
    # mathJS.Domains.N = new mathJS.Sets.N()
    Object.defineProperties mathJS.Domains, {
        R:
            value: new mathJS.Sets.R()
            writable: false
            enumerable: true
            configurable: false
    }
# end js/Sets/Domains/R.coffee

# from js/Sets/Domains/C.coffee
class mathJS.Sets.C extends _mathJS.Sets.Domain

    CLASS = @

    @new: () ->
        return new CLASS()

    constructor: () ->
        super("C", 4, false)

    #################################################################################
    # STATIC


    #################################################################################
    # PUBLIC
    contains: (x) ->
        return new mathJS.Number(x).equals(x)

    ###*
    * This method checks if `this` is a subset of the given set `set`. Since equality must be checked by checking an arbitrary number of values this method actually does the same as `this.equals()`. For `this.equals()` the number of compared elements is 10x bigger.
    *###
    isSubsetOf: (set, n = mathJS.settings.set.maxIterations) ->
        return @equals(set, n * 10)

    isSupersetOf: (set) ->
        if @_isSet set
            return set.isSubsetOf @
        return false

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

    @_makeAliases()


do () ->
    # mathJS.Domains.N = new mathJS.Sets.N()
    Object.defineProperties mathJS.Domains, {
        C:
            value: new mathJS.Sets.C()
            writable: false
            enumerable: true
            configurable: false
    }
# end js/Sets/Domains/C.coffee

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
            throw new mathJS.Errors.CalculationExceedanceError("Too many calculations (#{steps.toExponential()}) ahead! Either adjust mathJS.Integral.settings.maxSteps, set the Integral\"s instance\"s settings or pass settings to mathJS.Integral.solve() if you really need that many calculations.")

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
        return v instanceof mathJS.Vector or v.instanceof?(mathJS.Vector)# or v instanceof mathJS.Tuple or v.instanceof?(mathJS.Tuple)

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
     * It"s a shortcut for substracting 2 vectors and getting that vector"s magnitude (because no new object is created).
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
     * So on a computer grid the angle won"t be what you expect! Use anglePC() in that case!
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
# end js/LinearAlgebra/Vector.coffee

# from js/Initializer.coffee
class mathJS.Initializer

    @start: () ->
        mathJS.Algorithms.ShuntingYard.init()
# end js/Initializer.coffee

# from js/start.coffee
mathJS.Initializer.start()

if DEBUG
    diff = Date.now() - startTime
    console.log "time to load mathJS: ", diff, "ms"
    if diff > 100
        console.warn "LOADING TIME CRITICAL!"
# end js/start.coffee

