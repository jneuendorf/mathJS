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

    @getSet: () ->
        return mathJS.Domains.N


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

    getSet: () ->
        return mathJS.Domains.N
