class mathJS.Equation

    constructor: (left, right) ->
        if left.mathEquals(right)
            @left = left
            @right = right
        else
            # TODO: only if no variables are contained
            throw new mathJS.Errors.InvalidParametersError("The 2 expressions are not (mathematically) equal!")
