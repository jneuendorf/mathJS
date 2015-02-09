class mathJS.Generator

    @newFromMany: (generators...) ->
        # minX = generators.getMin (generator) ->
        #     return generator.minX

        # # is the offset to all 'child' generators
        # minX = 0
        #
        # maxX = generators.getMin (generator) ->
        #     return generator.maxX

        # 2x^2 - 3x, x in [0, 99]
        # x - 7    , x in (0, 1)

        generator = new mathJS.Generator(null, 0, Infinity, new mathJS.Tuple(generators))
        # generator.tuple = new mathJS.Tuple(generators)

        # TODO: each must be eval'd with its own minX to maxX
        generator.f = (n) ->
            return @tuple.eval(n)

        return generator

    constructor: (f, minX=0, maxX=Infinity, tuple) ->
        @f = f
        @minX = minX
        @maxX = maxX
        @tuple = tuple
        @index = minX

    eval: (n) ->
        # eval each tuple element individually
        if @tuple?
            return 2
        return @f.call(@, n)

    hasNext: () ->
        return @index < @maxX

    next: () ->
        return @f.call(@, @index++)

    reset: () ->
        @index = 0
        return @
