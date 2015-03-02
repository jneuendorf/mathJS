class _mathJS.Comparable extends _mathJS.Interface

    ###*
    * This method checks for mathmatical equality. This means new mathJS.Double(4.2).equals(4.2) is true.
    * @method equals
    * @param {Number} n
    * @return {Boolean}
    *###
    equals: (n) ->
        throw new mathJS.Errors.NotImplementedError("equals in #{@contructor.name}")

    e: () ->
        return @equals.apply(@, arguments)
