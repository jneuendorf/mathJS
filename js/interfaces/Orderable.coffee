class mathJS.Orderable extends mathJS.Comparable

    ###*
    * This method checks for mathmatical "<". This means new mathJS.Double(4.2).lessThan(5.2) is true.
    * @method lessThan
    * @param {Number} n
    * @return {Boolean}
    *###
    lessThan: (n) ->
        throw new Error("To be implemented!")

    ###*
    * Alias for `lessThan`.
    * @method lt
    *###
    lt: @::lessThan

    ###*
    * This method checks for mathmatical ">". This means new mathJS.Double(4.2).greaterThan(3.2) is true.
    * @method greaterThan
    * @param {Number} n
    * @return {Boolean}
    *###
    greaterThan: (n) ->
        throw new Error("To be implemented!")

    ###*
    * Alias for `greaterThan`.
    * @method lt
    *###
    gt: @::greaterThan

    ###*
    * This method checks for mathmatical "<=". This means new mathJS.Double(4.2).lessThanOrEqualTo(5.2) is true.
    * @method lessThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *###
    lessThanOrEqualTo: (n) ->
        throw new Error("To be implemented!")

    ###*
    * Alias for `lessThanOrEqualTo`.
    * @method lt
    *###
    lte: @::lessThanOrEqualTo

    ###*
    * This method checks for mathmatical ">=". This means new mathJS.Double(4.2).greaterThanOrEqualTo(3.2) is true.
    * @method greaterThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *###
    greaterThanOrEqualTo: (n) ->
        throw new Error("To be implemented!")

    ###*
    * Alias for `greaterThanOrEqualTo`.
    * @method lt
    *###
    gte: @::greaterThanOrEqualTo
