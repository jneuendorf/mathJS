class mathJS.Relation

    constructor: (left, right, operation) ->
        if left.mathEquals(right)
            @left = left
            @right = right
        else
            throw new mathJS.Errors.InvalidParametersError("The 2 expressions are not (mathematically) equal!")
