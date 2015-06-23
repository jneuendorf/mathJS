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
