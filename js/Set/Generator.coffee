
class mathJS.Generator

    @newFromGenerators: (g1, g2) ->
        return new mathJS.Generator()

    constructor: (step, offset) ->
        @step = step
        @offset = offset # this equals a left/right shift generator function
