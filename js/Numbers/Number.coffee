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
