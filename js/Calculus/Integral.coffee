class mathJS.Integral

    constructor: (integrand, leftBoundary=-Infinity, rightBoundary=Infinity, integrationVariable=new mathJS.Variable("x")) ->
        @integrand = integrand
        @leftBoundary = leftBoundary
        @rightBoundary = rightBoundary
        @integrationVariable = integrationVariable

    solve: (from, to, abs=false, stepSize=0.01) ->
        # absolute integral?
        if abs is false
            f = (x) ->
                return x
        else
            f = (x) ->
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

        res = 0

        x1 = from
        for x2 in [(from + stepSize)..to] by stepSize
            y1 = @integrand x1
            y2 = @integrand x2

            # 
