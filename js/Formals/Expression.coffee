###*
* Tree structure of expressions. It consists of 2 term and 1 operation.
* @class Expression

*###
class mathJS.Expression

    CLASS = @

    @fromString: (str) ->
        # TODO: parse string
        return new mathJS.Expression()


    # TODO: make those meaningful: eg. adjusted parameter lists?!
    @new: () ->
        return new CLASS()

    @newExpression = @new

    @newTerm: () ->

    # @stringToOperation: (opStr) ->
    #     return mathJS.Operations[opStr] or null

    constructor: (operation, terms...) ->
        if typeof operation is "string"
            if mathJS.Operations[operation]?
                operation = mathJS.Operations[operation]
            else
                throw new InvalidParametersError("Invalid operation string given: '#{operation}'.")

        # just 1 parameter => constant/value or hash given
        if terms.length is 0
            # constant value given => leaf in expression tree
            if mathJS.Number.valueIsValid(operation)
                @operation = null
                @terms = [new mathJS.Number(operation)]
            else
                throw new mathJS.Errors.InvalidParametersError("...")

        else if operation.arity is terms.length
            @operation = operation
            @terms = terms
        else
            throw new mathJS.Errors.InvalidArityError("Invalid number of parameters (#{terms.length}) for Operation '#{operation.name}'. Expected number of parameters is #{operation.arity}.")


    ###*
    * @method eval
    * @param values {Object}
    * An object of the form {varKey: varVal}.
    * @returns The value of the expression (specified by the values).
    *###
    eval: (values) ->
        # leaf => this.term1 is either a mathJS.Variable or a constant (-> Number)
        if not @operation?
            term = @terms.first
            # TODO: are numbers the only constants?
            if term instanceof mathJS.Number
                return term
            if values? and (value = values[term.name])?
                return term.eval(value)
            throw new mathJS.Errors.InvalidVariableError("Expected variable '#{term.name}' of type '#{term.type.name}'! But given #{JSON.stringify(values)}")

        # no leaf => eval substrees
        return @operation.eval(term.eval(values) for term in @terms)

    if DEBUG
        @test = () ->
            e1 = new CLASS(5)
            e2 = new CLASS(2)
            e3 = new CLASS(4)
            e4 = new CLASS("+", e1, e2)
            console.log e4.eval()
            e5 = new CLASS("*", e4, e3)
            # e5 = (5 + 2) * 4 = 28
            console.log e5.eval()
            return "test done"
