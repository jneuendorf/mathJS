###*
 * @class Int
 * @constructor
 * @param {Number} value
 * @extends Number
*###
class mathJS.Int extends mathJS.Number

    ###########################################################################
    # STATIC

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
    * @protected
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
        super(value)
        if (val = @_getPrimitiveInt(value))?
            @_value = val
        else
            throw new mathJS.Errors.InvalidParametersError(
                "Can't instatiate integer from given '#{value}'"
                "Int.coffee"
            )

    ###########################################################################
    # PRIVATE METHODS

    ###########################################################################
    # PROTECTED METHODS
    _getPrimitiveInt: (param) ->
        return @constructor._getPrimitiveInt(param)

    ###########################################################################
    # PUBLIC METHODS
    isEven: () ->
        return @value %% 2 is 0

    isOdd: () ->
        return @value %% 2 is 1

    toInt: () ->
        return mathJS.Int._fromPool @value

    getSet: () ->
        return mathJS.Domains.N
