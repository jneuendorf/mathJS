class mathJS.Fraction extends mathJS.Number

    ###*
    * @Override mathJS.Number
    * @static
    * @method fromPool
    *###
    @fromPool: (e, d) ->
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
        return @fromPool e, d

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
