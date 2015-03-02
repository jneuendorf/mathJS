class _mathJS.Orderable extends _mathJS.Comparable

    ###*
    * This method checks for mathmatical "<". This means new mathJS.Double(4.2).lessThan(5.2) is true.
    * @method lessThan
    * @param {Number} n
    * @return {Boolean}
    *###
    lessThan: (n) ->
        throw new mathJS.Errors.NotImplementedError("lessThan in #{@contructor.name}")

    ###*
    * Alias for `lessThan`.
    * @method lt
    *###
    lt: () ->
        return @lessThan.apply(@, arguments)

    ###*
    * This method checks for mathmatical ">". This means new mathJS.Double(4.2).greaterThan(3.2) is true.
    * @method greaterThan
    * @param {Number} n
    * @return {Boolean}
    *###
    greaterThan: (n) ->
        throw new mathJS.Errors.NotImplementedError("greaterThan in #{@contructor.name}")

    ###*
    * Alias for `greaterThan`.
    * @method gt
    *###
    gt: () ->
        return @greaterThan.apply(@, arguments)

    ###*
    * This method checks for mathmatical "<=". This means new mathJS.Double(4.2).lessThanOrEqualTo(5.2) is true.
    * @method lessThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *###
    lessThanOrEqualTo: (n) ->
        throw new mathJS.Errors.NotImplementedError("lessThanOrEqualTo in #{@contructor.name}")

    ###*
    * Alias for `lessThanOrEqualTo`.
    * @method lte
    *###
    lte: () ->
        return @lessThanOrEqualTo.apply(@, arguments)

    ###*
    * This method checks for mathmatical ">=". This means new mathJS.Double(4.2).greaterThanOrEqualTo(3.2) is true.
    * @method greaterThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *###
    greaterThanOrEqualTo: (n) ->
        throw new mathJS.Errors.NotImplementedError("greaterThanOrEqualTo in #{@contructor.name}")

    ###*
    * Alias for `greaterThanOrEqualTo`.
    * @method gte
    *###
    gte: () ->
        return @greaterThanOrEqualTo.apply(@, arguments)
