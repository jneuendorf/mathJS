###*
* Tree structure of expressions. It consists of 2 expression and 1 operation.
* @class Expression

*###
class mathJS.Expression

    CLASS = @

    @fromString: (str) ->
        # TODO: parse string
        return new mathJS.Expression()

    @parse = @fromString

    @parser = new mathJS.Algorithms.ShuntingYard(
    # TODO: use operations from operation class
        "!":
            precedence: 5
            associativity: "right"
        "^":
            precedence: 4
            associativity: "right"
        "*":
            precedence: 3
            associativity: "left"
        "/":
            precedence: 3
            associativity: "left"
        "+":
            precedence: 2
            associativity: "left"
        "-":
            precedence: 2
            associativity: "left"
    )


    # TODO: make those meaningful: eg. adjusted parameter lists?!
    @new: (operation, expressions...) ->
        return new CLASS(operation, expressions)

    constructor: (operation, expressions...) ->
        # map op string to actual operation object
        if typeof operation is "string"
            if mathJS.Operations[operation]?
                operation = mathJS.Operations[operation]
            else
                throw new mathJS.Errors.InvalidParametersError("Invalid operation string given: \"#{operation}\".")

        # if constructor was called from static .new()
        if expressions.first instanceof Array
            expressions = expressions.first

        # just 1 parameter => constant/value or hash given
        if expressions.length is 0
            # constant/variable value given => leaf in expression tree
            if mathJS.Number.valueIsValid(operation)
                @operation = null
                @expressions = [new mathJS.Number(operation)]
            else
                if operation instanceof mathJS.Variable
                    @operation = null
                    @expressions = [operation]
                # variable string. eg. "x"
                else
                    @operation = null
                    @expressions = [new mathJS.Variable(operation)]
            # else
            #     throw new mathJS.Errors.InvalidParametersError("...")

        else if operation.arity is expressions.length
            @operation = operation
            @expressions = expressions
        else
            throw new mathJS.Errors.InvalidArityError("Invalid number of parameters (#{expressions.length}) for Operation \"#{operation.name}\". Expected number of parameters is #{operation.arity}.")

    ###*
    * This method tests for the equality of structure. So 2*3x does not equal 6x!
    * For that see mathEquals().
    * @method equals
    *###
    equals: (expression) ->
        # immediate return if different number of sub expressions
        if @expressions.length isnt expression.expressions.length
            return false

        # leaf -> anchor
        if not @operation?
            return not expression.operation? and expression.expressions.first.equals(@expressions.first)

        # order of expressions doesnt matter
        if @operation.commutative is true
            doneExpressions = []
            for exp, i in @expressions
                res = false
                for x, j in expression.expressions when j not in doneExpressions and x.equals(exp)
                    doneExpressions.push j
                    res = true
                    break

                # exp does not equals any of the expressions => return false
                if not res
                    return false

            return true
        # order of expressions matters
        else
            # res = true
            for e1, i in @expressions
                e2 = expression.expressions[i]
                # res = res and e1.equals(e2)
                if not e1.equals(e2)
                    return false
            # return res
            return true

    ###*
    * This method tests for the logical/mathematical equality of 2 expressions.
    *###
    # TODO: change naming here! equals should always be mathematical!!!
    mathEquals: (expression) ->
        return @simplify().equals expression.simplify()

    ###*
    * @method eval
    * @param values {Object}
    * An object of the form {varKey: varVal}.
    * @returns The value of the expression (specified by the values).
    *###
    eval: (values) ->
        # replace primitives with mathJS objects
        for k, v of values
            if mathJS.isPrimitive(v) and mathJS.Number.valueIsValid(v)
                values[k] = new mathJS.Number(v)

        # leaf => first expression is either a mathJS.Variable or a constant (-> Number)
        if not @operation?
            return @expressions.first.eval(values)

        # no leaf => eval substrees
        args = []
        for expression in @expressions
            # evaluated expression is a variable => stop because this and the "above" expression cant be evaluated further
            value = expression.eval(values)
            if value instanceof mathJS.Variable
                return @
            # evaluation succeeded => add to list of evaluated values (which will be passed to the operation)
            args.push value

        return @operation.eval(args)

    simplify: () ->
        # simplify numeric values aka. non-variable arithmetics
        evaluated = @eval()
        # actual simplification: less ops!
        # TODO: gather simplification patterns
        return @

    getVariables: () ->
        if not @operation?
            if (val = @expressions.first) instanceof mathJS.Variable
                return [val]
            return []

        res = []
        for expression in @expressions
            res = res.concat expression.getVariables()
        return res

    _getSet: () ->
        # leaf
        if not @operation?
            return @expressions.first._getSet()

        # no leaf
        res = null
        for expression in @expressions
            if res?
                res = res[@operation.setEquivalent] expression._getSet()
            else
                res = expression._getSet()

        # TODO: the "or new mathJS.Set()" should be unnecessary
        return res or new mathJS.Set()

    ###*
    * Get the "range" of the expression (the set of all possible results).
    * @method getSet
    *###
    getSet: () ->
        return @eval()._getSet()

    # MAKE ALIASES
    evaluatesTo: @::getSet

    if DEBUG
        @test = () ->
            e1 = new CLASS(5)
            e2 = new CLASS(new mathJS.Variable("x", mathJS.Number))
            e4 = new CLASS("+", e1, e2)
            console.log e4.getVariables()
            # console.log e4.eval({x: new mathJS.Number(5)})
            # console.log e4.eval()
            # e5 = e4.eval()
            # console.log e5.eval({x: new mathJS.Number(5)})

            str = "(5x - 3)  ^ 2 * 2 / (4y + 3!)"

            # (5x-3)^2 * 2 / (4y + 6)

            return "test done"
