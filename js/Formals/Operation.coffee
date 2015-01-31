class mathJS.Operation

    constructor: (name, precedence, associativity="left", func, inverse) ->
        @name = name
        @precedence = precedence
        @associativity = associativity
        @func = func
        @params = func.length # number of parameters => unary, binary, ternary...
        @inverse = inverse or null

    invert: () ->
        if @inverse?
            return @inverse.apply(@, arguments)
        return null

mathJS.ops =
    pow:   new mathJS.Operation(
                "pow"
                1
                "right"
                mathJS.pow
                mathJS.root
            )
