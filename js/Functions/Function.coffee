class mathJS.Function

    constructor: (name, domain, range, variableNames, expression) ->
        @name = name
        @domain = domain
        @range = range
        @variableNames = variableNames
        @expression = expression

        @_cache = {}

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
    get: (values...) ->
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
    at: @get
