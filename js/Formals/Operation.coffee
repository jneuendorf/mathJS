class mathJS.Operation

    constructor: (name, precedence, associativity="left", commutative, func, inverse, setEquivalent) ->
        @name = name
        @precedence = precedence
        @associativity = associativity
        @commutative = commutative
        @func = func
        @arity = func.length # number of parameters => unary, binary, ternary...
        @inverse = inverse or null
        @setEquivalent = setEquivalent or null

    eval: (args) ->
        return @func.apply(@, args)

    invert: () ->
        if @inverse?
            return @inverse.apply(@, arguments)
        return null

# ABSTRACT OPERATIONS
# Those functions make sure primitives are converted correctly and calls the according operation on it"s first argument.
# They are the actual functions of the operations.
# TODO: no DRY
mathJS.Abstract =
    Operations:
        # arithmetical
        divide: (x, y) ->
            if mathJS.Number.valueIsValid(x) and mathJS.Number.valueIsValid(y)
                x = new mathJS.Number(x)
                y = new mathJS.Number(y)
            return x.divide(y)
        minus: (x, y) ->
            if mathJS.Number.valueIsValid(x) and mathJS.Number.valueIsValid(y)
                x = new mathJS.Number(x)
                y = new mathJS.Number(y)
            return x.minus(y)
        plus: (x, y) ->
            # numbers -> convert to mathJS.Number
            # => int to real
            if mathJS.Number.valueIsValid(x) and mathJS.Number.valueIsValid(y)
                x = new mathJS.Number(x)
                y = new mathJS.Number(y)
            # else if x instanceof mathJS.Variable or y instanceof mathJS.Variable
            #     return new mathJS.Expression(mathJS.Operations.plus, x, y)
            # else if x.plus?
            #     return x.plus(y)
            return x.plus(y)
            # throw new mathJS.Errors.InvalidParametersError("...")
        times: (x, y) ->
            # numbers -> convert to mathJS.Number
            # => int to real
            if mathJS.Number.valueIsValid(x) and mathJS.Number.valueIsValid(y)
                x = new mathJS.Number(x)
                y = new mathJS.Number(y)
            return x.times(y)
        negate: (x) ->
            if mathJS.Number.valueIsValid(x)
                x = new mathJS.Number(x)
            return x.negate()
        unaryPlus: (x) ->
            if mathJS.Number.valueIsValid(x)
                x = new mathJS.Number(x)
            return x.clone()
        # boolean / logical (converting from primitives to numbers doesn"t make sense because 3 and 4 is not defined)
        and: (x, y) ->
            return x.and(y)
        or: (x, y) ->
            return x.or(y)
        not: (x) ->
            return x.not()
        nand: (x, y) ->
            return x.nand(y)
        nor: (x, y) ->
            return x.nor(y)
        xor: (x, y) ->
            return x.xor(y)
        equals: (x, y) ->
            return x.equals(y)

###
PRECEDENCE (top to bottom):
(...)
factorial
unary +/-
exponents, roots
multiplication, division
addition, subtraction
###

cached =
    division: new mathJS.Operation(
        "divide"
        1
        "left"
        false
        mathJS.pow
        mathJS.root
    )
    addition: new mathJS.Operation(
        "plus"
        1
        "left"
        true
        mathJS.Abstract.Operations.plus
        mathJS.Abstract.Operations.minus
    )
    subtraction: new mathJS.Operation(
        "plus"
        1
        "left"
        false
        mathJS.Abstract.Operations.minus
        mathJS.Abstract.Operations.plus
    )
    multiplication: new mathJS.Operation(
        "times"
        1
        "left"
        true
        mathJS.Abstract.Operations.times
        mathJS.Abstract.Operations.divide
    )
    exponentiation: new mathJS.Operation(
        "pow"
        1
        "right"
        false
        mathJS.pow
        mathJS.root
    )
    factorial: new mathJS.Operation(
        "factorial"
        10
        "right"
        false
        mathJS.factorial
        mathJS.factorialInverse
    )
    negate: new mathJS.Operation(
        "negate"
        11
        "none"
        false
        mathJS.Abstract.Operations.negate
        mathJS.Abstract.Operations.negate
    )
    unaryPlus: new mathJS.Operation(
        "unaryPlus"
        11
        "none"
        false
        mathJS.Abstract.Operations.unaryPlus
        mathJS.Abstract.Operations.unaryPlus
    )
    and: new mathJS.Operation(
        "and"
        1
        "left"
        true
        mathJS.Abstract.Operations.and
        null
        "intersection"
    )
    or: new mathJS.Operation(
        "or"
        1
        "left"
        true
        mathJS.Abstract.Operations.or
        null
        "union"
    )
    not: new mathJS.Operation(
        "not"
        5
        "none"
        false
        mathJS.Abstract.Operations.not
        mathJS.Abstract.Operations.not
        "complement"
    )
    nand: new mathJS.Operation(
        "nand"
        1
        "left"
        true
        mathJS.Abstract.Operations.nand
        null
    )
    nor: new mathJS.Operation(
        "nor"
        1
        "left"
        true
        mathJS.Abstract.Operations.nor
        null
    )
    xor: new mathJS.Operation(
        "xor"
        1
        "left"
        true
        mathJS.Abstract.Operations.xor
        null
    )
    equals: new mathJS.Operation(
        "equals"
        1
        "left"
        true
        mathJS.Abstract.Operations.equals
        null
        "intersection"
    )


mathJS.Operations =
    # arithmetical
    "+":            cached.addition
    "plus":         cached.addition
    "-":            cached.subtraction
    "minus":        cached.subtraction
    "*":            cached.multiplication
    "times":        cached.multiplication
    "/":            cached.division
    ":":            cached.division
    "divide":       cached.division
    "^":            cached.exponentiation
    "pow":          cached.exponentiation
    "!":            cached.factorial
    "negate":       cached.negate
    "-u":           cached.negate
    "u-":           cached.negate
    "unaryMinus":   cached.negate
    "neutralMinus": cached.negate
    "+u":           cached.unaryPlus
    "u+":           cached.unaryPlus
    "unaryPlus":    cached.unaryPlus
    "neutralPlus":  cached.unaryPlus
    # logical
    "and":          cached.and
    "or":           cached.or
    "not":          cached.not
    "nand":         cached.nand
    "nor":          cached.nor
    "xor":          cached.xor
    "equals":       cached.equals
    "=":            cached.equals
    "xnor":         cached.equals
