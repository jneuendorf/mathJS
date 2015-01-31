class mathJS.Integral

    CLASS = @

    if DEBUG
        @test = () ->
            i = new mathJS.Integral(
                (x) ->
                    return -2*x*x-3*x+10
                -3
                1
            )
            start = Date.now()
            console.log i.solve(false, 0.00000000000001), Date.now() - start
            start = Date.now()
            i.solveAsync(
                (res) ->
                    console.log res, "async took:", Date.now() - start
                false
                0.0000001
            )
            start2 = Date.now()
            console.log i.solve(), Date.now() - start2

            return "test done"

    constructor: (integrand, leftBoundary=-Infinity, rightBoundary=Infinity, integrationVariable=new mathJS.Variable("x")) ->
        @integrand = integrand
        @leftBoundary = leftBoundary
        @rightBoundary = rightBoundary
        @integrationVariable = integrationVariable

        @settings = null

    # PRIVATE
    _solvePrepareVars = (from, to, abs, stepSize) ->
        # absolute integral?
        if abs is false
            modVal = mathJS.id
        else
            modVal = (x) ->
                return Math.abs(x)

        # get primitives
        from = from.value or from
        to = to.value or to

        # swap if in wrong order
        if to < from
            tmp = to
            to = from
            from = tmp

        if (diff = to - from) < stepSize
            # stepSize = diff * stepSize * 0.1
            stepSize = diff * 0.001

        return {
            modVal: modVal
            from: from
            to: to
            stepSize: stepSize
        }

    # STATIC
    @solve = (integrand, from, to, abs=false, stepSize=0.01, settings={}) ->
        vars = _solvePrepareVars(from, to, abs, stepSize)

        modVal = vars.modVal
        from = vars.from
        to = vars.to
        stepSize = vars.stepSize

        if (steps = (to - from) / stepSize) > settings.maxSteps or mathJS.settings.integral.maxSteps
            throw new mathJS.CalculationExceedanceError("Too many calculations (#{steps.toExponential()}) ahead! Either adjust mathJS.Integral.settings.maxSteps, set the Integral's instance's settings or pass settings to mathJS.Integral.solve() if you really need that many calculations.")

        res = 0

        # cache 0.5 * stepSize
        halfStepSize = 0.5 * stepSize

        y1 = integrand(from)
        if DEBUG
            i = 0
        for x2 in [(from + stepSize)..to] by stepSize
            if DEBUG
                i++
            y2 = integrand(x2)

            if mathJS.sign(y1) is mathJS.sign(y2)
                # trapezoid formula
                res += modVal((y1 + y2) * halfStepSize)
            # else: round to zero -> no calculation needed

            y1 = y2

        if DEBUG
            console.log "made", i, "calculations"

        return res

    ###*
    * For better calculation performance of the integral decrease delay and numBlocks.
    * For better overall performance increase them.
    * @public
    * @static
    * @method solveAsync
    * @param integrand {Function}
    * @param from {Number}
    * @param to {Number}
    * @param callback {Function}
    * @param abs {Boolean}
    * Optional. Indicates whether areas below the graph are negative or not.
    * Default is false.
    * @param stepSize {Number}
    * Optional. Defines the width of each trapezoid. Default is 0.01.
    * @param delay {Number}
    * Optional. Defines the time to pass between blocks of calculations.
    * Default is 2ms.
    * @param numBlocks {Number}
    * Optional. Defines the number of calculation blocks.
    * Default is 100.
    *###
    @solveAsync: (integrand, from, to, callback, abs, stepSize, delay=2, numBlocks=100) ->
        if not callback?
            return false

        # split calculation into numBlocks blocks
        blockSize = (to - from) / numBlocks
        block = 0

        res = 0

        f = (from, to) ->
            # done with all blocks => return result to callback
            if block++ is numBlocks
                return callback(res)

            res += CLASS.solve(integrand, from, to, abs, stepSize)

            setTimeout  () ->
                            f(to, to + blockSize)
                        , delay

            return true

        f(from, from + blockSize)

        return @

    # PUBLIC
    solve: (abs, stepSize) ->
        return CLASS.solve(@integrand, @leftBoundary, @rightBoundary, abs, stepSize)

    solveAsync: (callback, abs, stepSize) ->
        return CLASS.solveAsync(@integrand, @leftBoundary, @rightBoundary, callback, abs, stepSize)
