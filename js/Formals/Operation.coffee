class mathJS.Operation

    constructor: (name, precedence, associativity="left", func, inverse) ->
        @name = name
        @precedence = precedence
        @associativity = associativity
        @func = func
        @arity = func.length # number of parameters => unary, binary, ternary...
        @inverse = inverse or null

    eval: (args) ->
        return @func.apply(@, args)

    invert: () ->
        if @inverse?
            return @inverse.apply(@, arguments)
        return null

mathJS.Abstract =
    Operations:
        plus: (x, y) ->
            # numbers -> convert to mathJS.Number
            # => int to real
            if mathJS.Number.valueIsValid(x) and mathJS.Number.valueIsValid(y)
                x = new mathJS.Number(x)
                y = new mathJS.Number(y)
            if x.plus?
                return x.plus(y)
            throw new mathJS.Errors.InvalidParametersError("...")
        minus: () ->
        times: (x, y) ->
            # numbers -> convert to mathJS.Number
            # => int to real
            if mathJS.Number.valueIsValid(x) and mathJS.Number.valueIsValid(y)
                x = new mathJS.Number(x)
                y = new mathJS.Number(y)
            if x.plus?
                return x.times(y)
            throw new mathJS.Errors.InvalidParametersError("...")



cached =
    division: new mathJS.Operation(
        "divide"
        1
        "right"
        mathJS.pow
        mathJS.root
    )
    addition: new mathJS.Operation(
        "plus"
        1
        "left"
        mathJS.Abstract.Operations.plus
        mathJS.Abstract.Operations.minus
    )
    # subtraction: new mathJS.Operation()
    multiplication: new mathJS.Operation(
        "times"
        1
        "left"
        mathJS.Abstract.Operations.times
        mathJS.Abstract.Operations.divide
    )
    # exponentiation: new mathJS.Operation()
    # factorial: new mathJS.Operation()


mathJS.Operations =
    "+": cached.addition
    "-": cached.subtraction
    "*": cached.multiplication
    "/": cached.division
    ":": cached.division
    "^": cached.exponentiation
    "!": cached.factorial

    pow: new mathJS.Operation(
            "pow"
            1
            "right"
            mathJS.pow
            mathJS.root
    )
