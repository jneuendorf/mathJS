class mathJS.Function extends mathJS.Set

    # EQUAL!
    # function:
    # f: X -> Y, f(x) = 3x^2 - 5x + 7
    # set:
    # {(x, 3x^2 - 5x + 7) | x in X}

    # domain is implicit by variables' types contained in the expression
    # range is implicit by the expression
    # constructor: (name, domain, range, expression) ->
    constructor: (name, expression, domain, range) ->
        @name = name
        @expression = expression

        if domain instanceof mathJS.Set
            @domain = domain
        else
            @domain = new mathJS.Set(expression.getVariables())

        if range instanceof mathJS.Set
            @range = range
        else
            @range = expression.getSet()

        @_cache = {}
        @caching = true

        super()

    ###*
    * Empty the cache or reset to given cache.
    * @method clearCache
    * @param cache {Object}
    * @return mathJS.Function
    * @chainable
    *###
    clearCache: (cache) ->
        if not cache?
            @_cache = {}
        else
            @_cache = cache
        return @

    ###*
    * Evaluate the function for given values.
    * @method get
    * @param values {Array|Object}
    * If an array the first value will be associated with the first variable name. Otherwise an object like {x: 42} is expected.
    * @return
    *###
    eval: (values...) ->
        tmp = {}
        if values instanceof Array
            for value, i in values
                tmp[@variableNames[i]] = value
            values = tmp

        # check if values are in domain
        for varName, val of values
            if not domain.contains(val)
                return null

        return @expression.eval(values)

    # make alias
    at: @eval
    get: @eval
