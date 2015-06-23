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
