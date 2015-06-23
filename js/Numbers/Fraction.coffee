class mathJS.Fraction extends mathJS.Number

    ###*
    * @Override mathJS.Number
    * @static
    * @method _fromPool
    *###
    @_fromPool: (numerator, denominator) ->
        if @_pool.length > 0
            if (e = @_getPrimitiveFrac(numerator))? and (d = @_getPrimitiveFrac(denominator))?
                frac = @_pool.pop()
                frac.numerator = e
                frac.denominator = d
                return frac
            throw new mathJS.Errors.InvalidParametersError(
                "Can't instatiate fraction from given '#{numerator}, #{denominator}'"
                "Fraction.coffee"
            )
        else
            # param check is done in constructor
            return new @(numerator, denominator)

    ###*
    * This method parses strings of the form "x / y" or "x : y".
    * @Override mathJS.Number
    * @static
    * @method parse
    *###
    @parse: (str) ->
        if "/" in str
            parts = str.split "/"
            return @new parts.first, parts.second

        num = parseFloat(str)
        if not isNaN(num)
            # TODO
            numerator = num
            denominator = 1
            # 123.456 = 123456 / 1000
            while numerator % 1 isnt 0
                numerator *= 10
                denominator *= 10
            return @new(numerator, denominator)
        throw new mathJS.Errors.NotParseableError("Can't parse '#{str}' as fraction!")

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

    @_getPrimitiveFrac: (param, skipCheck) ->
        return mathJS.Int._getPrimitiveInt(param, skipCheck)

    ###########################################################################
    # CONSTRUCTOR
    constructor: (numerator, denominator) ->
        @_numerator = null
        @_denominator = null

        Object.defineProperties @, {
            numerator:
                get: () ->
                    return @_numerator
                set: @_setValue
            denominator:
                get: () ->
                    return @_denominator
                set: @_setValue
        }

        if (e = @_getPrimitiveFrac(numerator))? and (d = @_getPrimitiveFrac(denominator))?
            # TODO: when sth. like 12.55 / 0.8 is given => create 12.55*100 / 0.8*100 = 1255 / 80
            if d is 0
                throw new mathJS.Error.DivisionByZeroError("Denominator is 0 (when creating fraction)!")
            @_numerator = e
            @_denominator = d
        else
            throw new mathJS.Errors.InvalidParametersError(
                "Can't instatiate fraction from given '#{numerator}, #{denominator}'"
                "Fraction.coffee"
            )

    ############################################################################################
    # PROTECTED METHODS
    _getPrimitiveFrac: (param) ->
        return @constructor._getPrimitiveFrac(param)

    ############################################################################################
    # PUBLIC METHODS
