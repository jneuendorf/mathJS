class mathJS.Generator

    @newFromMany: (generators...) ->
        return new mathJS.Generator(null, 0, Infinity, null, null, new mathJS.Tuple(generators))

    constructor: (f, minX=0, maxX=Infinity, stepSize=mathJS.config.number.real.distance, maxIndex=mathJS.config.generator.maxIndex, tuple) ->
        @f = f
        @inverseF = f.getInverse()
        @minX = minX
        @maxX = maxX
        @stepSize = stepSize
        @maxIndex = maxIndex
        @tuple = tuple

        @x = minX
        @overflowed = false
        @index = 0

    Object.defineProperties @::, {
        function:
            get: () ->
                return @f
            set: (f) ->
                @f = f
                @inverseF = f.getInverse()
                return @
    }

    ###*
    * Indicates whether the set the generator creates contains the given value or not.
    * @method generates
    *###
    generates: (y) ->
        if @f.range.contains(y)
            #
            if @inverseF?
                return @inverseF.'eval'(y)
            return
        return false

    'eval': (n) ->
        # 'eval' each tuple element individually (the tuple knows how to do that)
        if @tuple?
            return @tuple.'eval'(n)
        # 'eval' expression
        if @f.'eval'?
            @f.'eval'(n)
        # 'eval' js function
        return @f.call(@, n)

    hasNext: () ->
        if @tuple?
            for g, i in @tuple.elems when g.hasNext()
                return true
            return false
        return not @overflowed and @x < @maxX and @index < @maxIndex

    _incX: () ->
        @index++
        # more calculation than just "@x += @stepSize" but more precise!
        @x = @minX + @index * @stepSize

        if @x > @maxX
            @x = @minX
            @index = 0
            @overflowed = true
        return @x

    next: () ->
        if @tuple?
            res = @'eval'(g.x for g in @tuple.elems)

            ###
            0 0
            0 1
            1 0
            1 1
            ###
            # start binary-like counting (so all possibilities are done)
            i = 0
            maxI = @tuple.length
            generator = @tuple.first
            generator._incX()

            while i < maxI and generator.overflowed
                generator.overflowed = false
                generator = @tuple.at(++i)
                # # "if" needed for very last value -> i should theoretically overflow
                # => i refers to the (n+1)st tuple element (which only has n elements)
                if generator?
                    generator._incX()

            return res

        # no tuple => simple generator
        res = @'eval'(@x)
        @_incX()
        return res

    reset: () ->
        @x = @minX
        @index = 0
        return @

    if DEBUG
        @test = () ->
            # simple
            g = new mathJS.Generator(
                (x) ->
                    return 3*x*x+2*x-5
                -10
                10
                0.2
            )

            res = []
            while g.hasNext()
                tmp = g.next()
                # console.log tmp
                res.push tmp

            tmp = g.next()
            # console.log tmp
            res.push tmp

            console.log "simple test:", (if res.length is ((g.maxX - g.minX) / g.stepSize + 1) then "successful" else "failed")

            # "nested"
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
                # console.log (x.value for x in tmp.elems)

            tmp = g.next()
            res.push tmp
            # console.log (x.value for x in tmp.elems)

            console.log "tuple test:", (if res.length is ((g1.maxX - g1.minX) / g1.stepSize + 1) * ((g2.maxX - g2.minX) / g2.stepSize + 1) then "successful" else "failed")

            g = new mathJS.Generator((x) -> x)

            while g.hasNext()
                tmp = g.next()
                # console.log tmp
            tmp = g.next()
            # console.log tmp

            return "done"
