# This file defines the Number interface.
# TODO: make number extend expression
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
                number.value = val
                return number
            throw new mathJS.Errors.InvalidParametersError(
                "Can't instatiate number from given '#{value}'"
                "AbstractNumber.coffee"
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
        mathJS.Fraction
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
        if (result = @constructor.dispatcher.dispatch(n, "equals", @))?
            return result

        if (val = @_getPrimitive(n))?
            return @value is val
        return false
    # END - IMPLEMENTING COMPARABLE
    ############################################################################################

    ############################################################################################
    # ORDERABLE INTERFACE
    ###*
    * @Override mathJS.Orderable
    * This method checks for mathmatical "<". This means new mathJS.Double(4.2).lessThan(5.2) is true.
    * @method lessThan
    *###
    lessThan: (n) ->
        if (result = @constructor.dispatcher.dispatch(n, "lessThan", @))?
            return result

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
        if (result = @constructor.dispatcher.dispatch(n, "greaterThan", @))?
            return result

        if (val = @_getPrimitive(n))?
            return @value > val
        return false
    # END - IMPLEMENTING ORDERABLE
    ############################################################################################

    ###*
    * This method adds 2 numbers and returns a new one.
    * @method plus
    * @param {Number} n
    * @return {mathJS.Number} Calculated Number.
    *###
    plus: (n) ->
        if (result = @constructor.dispatcher.dispatch(n, "plus", @))?
            return result

        if (val = @_getPrimitive(n))?
            return mathJS.Number.new(@value + val)

        throw new mathJS.Errors.InvalidParametersError(
            "Can't instatiate number from given '#{n}'"
            "AbstractNumber.coffee"
        )

    ###*
    * This method substracts 2 numbers and returns a new one.
    * @method minus
    * @param {Number} n
    * @return {mathJS.Number} Calculated Number.
    *###
    minus: (n) ->
        if (result = @constructor.dispatcher.dispatch(n, "minus", @))?
            return result

        if (val = @_getPrimitive(n))?
            return mathJS.Number.new(@value - val)

        throw new mathJS.Errors.InvalidParametersError(
            "Can't instatiate number from given '#{n}'"
            "AbstractNumber.coffee"
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
        )

    ###*
    * This method divides 2 numbers and returns a new one.
    * @method divide
    * @param {Number} n
    * @return {Number} Calculated Number.
    *###
    divide: (n) ->
        if (result = @constructor.dispatcher.dispatch(n, "divide", @))?
            return result

        if (val = @_getPrimitive(n))?
            return mathJS.Number.new(@value / val)

        throw new mathJS.Errors.InvalidParametersError(
            "Can't instatiate number from given '#{n}'"
            "AbstractNumber.coffee"
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
