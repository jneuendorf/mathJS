# This file defines the Number interface.
class _mathJS.AbstractNumber extends _mathJS.Object

    @implement _mathJS.Orderable, _mathJS.Poolable, _mathJS.Parseable

    ###*
    * @Override mathJS.Poolable
    * @static
    * @method fromPool
    *###
    @fromPool: (val) ->

    ###*
    * @Override mathJS.Parseable
    * @static
    * @method parse
    *###
    @parse: (str) ->

    @getSet: () ->

    @new: (value) ->
        return @fromPool value

    ############################################################################################
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
        return @value is @_getValueFromParam(n)

    ###*
    * @Override mathJS.Orderable
    * This method checks for mathmatical "<". This means new mathJS.Double(4.2).lessThan(5.2) is true.
    * @method lessThan
    *###
    lessThan: (n) ->
        return @value < @_getValueFromParam(n)

    ###*
    * @Override mathJS.Orderable
    * This method checks for mathmatical ">". This means new mathJS.Double(4.2).greaterThan(3.2) is true.
    * @method greaterThan
    * @param {Number} n
    * @return {Boolean}
    *###
    greaterThan: (n) ->
        return @value > @_getValueFromParam(n)

    ###*
    * @Override mathJS.Orderable
    * This method checks for mathmatical "<=".
    * @method lessThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *###
    lessThanOrEqualTo: (n) ->
        return @value <= @_getValueFromParam(n)

    ###*
    * This method checks for mathmatical ">=".
    * @method greaterThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *###
    greaterThanOrEqualTo: (n) ->
        return @value >= @_getValueFromParam(n)
    # END - IMPLEMENTING COMPARABLE
    ############################################################################################

    ###*
    * This method adds 2 numbers and returns a new one.
    * @method plus
    * @param {Number} n
    * @return {Number} Calculated Number.
    *###
    plus: (n) ->
        return @fromPool(@value + @_getValueFromParam(n))

    ###*
    * This method substracts 2 numbers and returns a new one.
    * @method minus
    * @param {Number} n
    * @return {Number} Calculated Number.
    *###
    minus: (n) ->
        return @fromPool(@value - n)

    ###*
    * This method multiplies 2 numbers and returns a new one.
    * @method times
    * @param {Number} n
    * @return {Number} Calculated Number.
    *###
    times: (n) ->
        return @fromPool(@value * @_getValueFromParam(n))

    ###*
    * This method divides 2 numbers and returns a new one.
    * @method divide
    * @param {Number} n
    * @return {Number} Calculated Number.
    *###
    divide: (n) ->
        return @fromPool(@value / @_getValueFromParam(n))

    ###*
    * This method squares this instance and returns a new one.
    * @method square
    * @return {Number} Calculated Number.
    *###
    square: () ->
        return @fromPool(@value * @value)

    ###*
    * This method cubes this instance and returns a new one.
    * @method cube
    * @return {Number} Calculated Number.
    *###
    cube: () ->
        return @fromPool(@value * @value * @value)

    ###*
    * This method calculates the square root of this instance and returns a new one.
    * @method sqrt
    * @return {Number} Calculated Number.
    *###
    sqrt: () ->
        return @fromPool mathJS.sqrt(@value)

    ###*
    * This method calculates the cubic root of this instance and returns a new one.
    * @method curt
    * @return {Number} Calculated Number.
    *###
    curt: () ->
        return @pow(1 / 3)

    ###*
    * This method calculates any root of this instance and returns a new one.
    * @method plus
    * @param {Number} exponent
    * @return {Number} Calculated Number.
    *###
    root: (exp) ->

    ###*
    * This method adds 2 numbers and returns a new one.
    * @method plus
    * @param {Number} n
    * @return {Number} Calculated Number.
    *###
    reciprocal: () ->

    ###*
    * This method adds 2 numbers and returns a new one.
    * @method plus
    * @param {Number} n
    * @return {Number} Calculated Number.
    *###
    pow: (n) ->
        return @fromPool mathJS.pow @value, @_getValueFromParam(n)

    sign: () ->

    negate: () ->

    toInt: () ->

    toDouble: () ->

    toString: () ->

    clone: () ->

    # EVALUABLE INTERFACE
    eval: (values) ->
        return @

    _getSet: () ->
        return new mathJS.Set(@)

    ############################################################################################
    # PRE-IMPLEMENTED
    in: (set) ->
        return set.contains(@)
