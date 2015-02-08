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

    negate: () ->
        return @fromPool -@value

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

    valueOf: @::_getValue
