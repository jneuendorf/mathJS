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

        generator = new mathJS.Generator(null, 0, Infinity, null, new mathJS.Tuple(generators), generators.first)
        # generator.x = (g.minX for g in generators)
        # generator.tuple = new mathJS.Tuple(generators)

        # TODO: each must be eval'd with its own minX to maxX
        # generator.f = (n) ->
        #     return @tuple.eval(n)

        return generator

    constructor: (f, minX=0, maxX=Infinity, stepSize=mathJS.config.number.real.distance, tuple, currentGenerator) ->
        @f = f
        @minX = minX
        @maxX = maxX
        @stepSize = stepSize
        @tuple = tuple
        @currentGenerator = currentGenerator
        @x = minX
        @overflowed = false

    eval: (n) ->
        # eval each tuple element individually (the tuple knows how to do that)
        if @tuple?
            return @tuple.eval(n)
        return @f.call(@, n)

    hasNext: () ->
        if @tuple?
            for g, i in @tuple.elems when g.hasNext()
                return true
            return false
        return @x < @maxX

    _incX: () ->
        @x += @stepSize
        if @x > @maxX
            @x = @minX
            @overflowed = true
        return @x

    next: () ->
        ###
        0 0 0
        0 0 1
        0 1 0
        0 1 1
        1 0 0
        1 0 1
        1 1 0
        1 1 1
        ###
        if @tuple?
            res = @eval(g.x for g in @tuple.elems)

            # start binary-like counting (so all possibilities are done)
            i = 0
            maxI = @tuple.length
            generator = @tuple.first
            generator._incX()

            while i < maxI and generator.overflowed
                generator.overflowed = false
                generator = @tuple.at(++i)
                # # 'if' needed for very last value -> i should theoretically overflow
                if generator?
                    generator._incX()
                # generator._incX()

            return res

        # no tuple => simple generator
        # if @overflowed
        #     @overflowed = false
        res = @eval(@x)
        @_incX()
        return res

    reset: () ->
        @x = @minX
        return @

    if DEBUG
        @test = () ->
            g1 = new mathJS.Generator(
                (x) -> x,
                0,
                5,
                0.5
            )
            g2 = new mathJS.Generator(
                (x) -> 2*x,
                -2,
                10,
                2
            )
            g = mathJS.Generator.newFromMany(g1, g2)

            res = []
            while g.hasNext()
                tmp = g.next()
                res.push tmp
                console.log (x.value for x in tmp.elems)

            tmp = g.next()
            res.push tmp
            console.log (x.value for x in tmp.elems)

            return res.length is ((5-0)/0.5 + 1) * ((10 - (-2))/2 + 1)
