class mathJS.Equation

    constructor: (left, right) ->
        # if left.mathEquals(right)
        #     @left = left
        #     @right = right
        # else
        #     # TODO: only if no variables are contained
        #     throw new mathJS.Errors.InvalidParametersError("The 2 expressions are not (mathematically) equal!")
        @left = left
        @right = right

    solve: (variable) ->
        left = @left.simplify()
        right = @right.simplify()

        solutions = new mathJS.Set()

        # convert to actual variable if only the name was given
        if variable not instanceof mathJS.Variable
            variables = left.getVariables().concat right.getVariables()
            variable = (v for v in variables when v.name is variable).first

        return solutions

    'eval': (values) ->
        return @left.'eval'(values).equals @right.'eval'(values)

    simplify: () ->
        @left = @left.simplify()
        @right = @right.simplify()
        return @

    # MAKE ALIASES
    # ...
